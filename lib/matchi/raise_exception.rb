# frozen_string_literal: true

require_relative "constant"

module Matchi
  # Exception matcher: passes when evaluating the block raises an exception
  # of the expected class or of one of its descendants (`Module#===`, so the
  # exception cannot lie about its class), optionally with an expected
  # message: a String the message must be `eql?` to, or a Regexp it must
  # match.
  #
  # The matcher rescues an exception of the expected class, and any
  # `StandardError`, `ScriptError`, `SystemStackError` or `SystemExit`,
  # which it then compares with the expected class. Anything else, an
  # `Interrupt`, a signal, a `NoMemoryError`, the exception with which an
  # enclosing `Timeout` ends its block, goes through as it would with any
  # other matcher, unless that is the class expected. The expected class can
  # be given directly, or by name; see {Matchi::Constant}.
  #
  # @example
  #   Matchi::RaiseException.new(ZeroDivisionError).match? { 1 / 0 }              # => true
  #   Matchi::RaiseException.new(:StandardError).match? { 1 / 0 }                 # => true
  #   Matchi::RaiseException.new(ZeroDivisionError, /by 0/).match? { 1 / 0 }      # => true
  #   Matchi::RaiseException.new(ZeroDivisionError, "nope").match? { 1 / 0 }      # => false
  #   Matchi::RaiseException.new(IOError).match? { 1 / 0 }                        # => false
  class RaiseException
    # @param expected [Class, String, Symbol] the expected exception class, or its name
    # @param message [String, Regexp, nil] the expected message, exact or as a pattern
    # @raise [ArgumentError] when expected is neither an Exception class nor a constant name,
    #   or message is neither a String nor a Regexp
    def initialize(expected, message = nil)
      @expected = Constant.normalize(expected, ::Class)
      @message = message
      validate_class!
      validate_message!
    end

    # @yieldreturn [Object] ignored, the block is evaluated for its exception
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [NameError] when the name is not defined
    # @raise [TypeError] when the name does not resolve to an Exception class
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      # Resolved before the block, so that a NameError from the name is not
      # mistaken for an exception raised by the block.
      klass = expected_class

      # The expected class first, whatever it is; then what a block raises
      # on its own, the exceptions Defi keeps too.
      begin
        yield
        false
      rescue klass => e
        message?(e)
      rescue ::StandardError, ::ScriptError, ::SystemStackError, ::SystemExit
        false
      end
    end

    # @return [String]
    def to_s
      return "raise exception #{Constant.label(@expected)}" if @message.nil?

      "raise exception #{Constant.label(@expected)} with message #{@message.inspect}"
    end

    private

    def validate_class!
      return unless ::Class === @expected
      return if @expected <= ::Exception

      raise ::ArgumentError, "expected must inherit from Exception (got: #{@expected.inspect})"
    end

    def validate_message!
      return if @message.nil? || ::String === @message || ::Regexp === @message

      raise ::ArgumentError, "message must be a String or a Regexp (got: #{@message.inspect})"
    end

    def expected_class
      return @expected if ::Class === @expected

      klass = Constant.resolve(@expected, ::Class)
      raise ::TypeError, "#{@expected} is not an Exception class" unless klass <= ::Exception

      klass
    end

    # The message is whatever the exception answers to `message`, which is
    # its own data, as with any exception; it must be a String, copied so
    # that a subclass has no say, and valid. The expected String or Regexp
    # receives the comparison.
    def message?(exception)
      return true if @message.nil?

      message = exception.message
      return false unless ::String === message

      message = ::String.new(message)
      return false unless message.valid_encoding?

      ::String === @message ? @message.eql?(message) : @message.match?(message)
    rescue ::Encoding::CompatibilityError
      false
    end
  end
end
