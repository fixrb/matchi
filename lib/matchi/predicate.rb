# frozen_string_literal: true

require_relative "constant"

module Matchi
  # Predicate matcher: passes when a predicate method of the actual value
  # returns `true`. The matcher name `be_xxx` calls `xxx?`, and `have_xxx`
  # calls `has_xxx?`, with `Kernel#public_send` bound to the actual value.
  # The predicate must return `true` or `false`; any other value is an error,
  # not a truthy pass.
  #
  # Since the actual value answers the call, this matcher depends on the
  # honesty of the object under test. Use it for the object's own documented
  # predicates.
  #
  # @example
  #   Matchi::Predicate.new(:be_empty).match? { [] }           # => true
  #   Matchi::Predicate.new(:have_key, :a).match? { { a: 1 } } # => true
  class Predicate
    # A matcher name: `be_` or `have_`, then a letter, then letters, digits
    # or underscores, in any script. It never ends with `?` or `!`.
    NAME = /\A(be|have)_\p{Alpha}[\p{Alnum}_]*\z/

    # @param name [Symbol, String] `be_xxx` or `have_xxx`
    # @param args [Array] positional arguments for the predicate
    # @param kwargs [Hash] keyword arguments for the predicate
    # @param block [Proc, nil] a block for the predicate
    # @raise [ArgumentError] when the name does not start with be_ or have_
    def initialize(name, *args, **kwargs, &block)
      @name = String(name)
      raise ::ArgumentError, "name must match #{NAME.inspect} (got: #{name.inspect})" unless NAME.match?(@name)

      @method_name = method_name
      @args = args
      @kwargs = kwargs
      @block = block
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [TypeError] when the predicate returns something other than true or false
    # @raise [NoMethodError] when the actual value has no such public predicate
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      result = ::Kernel.instance_method(:public_send).bind_call(yield, @method_name, *@args, **@kwargs, &@block)
      return result if true.equal?(result) || false.equal?(result)

      raise ::TypeError, "#{@method_name} must return true or false (got a #{Constant.label(result_class(result))})"
    end

    # @return [String]
    def to_s
      arguments = @args.map(&:inspect) + @kwargs.map { |key, value| "#{key}: #{value.inspect}" }
      arguments << "&block" if @block

      [@name.tr("_", " "), arguments.join(", ")].reject(&:empty?).join(" ")
    end

    private

    def method_name
      return "#{@name.delete_prefix("be_")}?" if @name.start_with?("be_")

      "has_#{@name.delete_prefix("have_")}?"
    end

    def result_class(result)
      ::Kernel.instance_method(:class).bind_call(result)
    end
  end
end
