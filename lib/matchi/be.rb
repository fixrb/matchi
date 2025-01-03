# frozen_string_literal: true

module Matchi
  # *Identity* matcher.
  class Be
    # Initialize the matcher with an object.
    #
    # @example
    #   require "matchi/be"
    #
    #   Matchi::Be.new(:foo)
    #
    # @param expected [#equal?] The expected identical object.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/be"
    #
    #   matcher = Matchi::Be.new(:foo)
    #   matcher.match? { :foo } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.equal?(yield)
    end

    # Returns a string representing the matcher.
    #
    # @return [String] a human-readable description of the matcher
    def to_s
      "be #{@expected.inspect}"
    end
  end
end
