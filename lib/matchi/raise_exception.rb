# frozen_string_literal: true

module Matchi
  # *Expecting errors* matcher.
  class RaiseException
    # Initialize the matcher with a descendant of class Exception.
    #
    # @example
    #   require "matchi/raise_exception"
    #
    #   Matchi::RaiseException.new(NameError)
    #
    # @param expected [Exception, #to_s] The expected exception name.
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ::ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/raise_exception"
    #
    #   matcher = Matchi::RaiseException.new(NameError)
    #   matcher.match? { Boom } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      klass = expected_class
      raise ::ArgumentError, "expected exception class must inherit from Exception" unless klass <= ::Exception

      begin
        yield
        false
      rescue Exception => e # rubocop:disable Lint/RescueException
        e.class <= klass # Checks if the class of the thrown exception is klass or one of its subclasses
      end
    end

    # Returns a string representing the matcher.
    #
    # @return [String] a human-readable description of the matcher
    def to_s
      "raise exception #{@expected}"
    end

    private

    # Resolves the expected class name to an actual Class object.
    # This method handles both string and symbol class names through constant resolution.
    #
    # @return [Class] the resolved class
    # @raise [NameError] if the class doesn't exist
    def expected_class
      ::Object.const_get(@expected)
    end
  end
end
