# frozen_string_literal: true

module Matchi
  # *Satisfy* matcher.
  class Satisfy
    # Initialize the matcher with a block.
    #
    # @example
    #   require "matchi/satisfy"
    #
    #   Matchi::Satisfy.new { |value| value == 42 }
    #
    # @param block [Proc] A block of code.
    def initialize(&block)
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected = block
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/satisfy"
    #
    #   matcher = Matchi::Satisfy.new { |value| value == 42 }
    #   matcher.match? { 42 } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.call(yield)
    end

    # Returns a string representing the matcher.
    #
    # @return [String] a human-readable description of the matcher
    def to_s
      "satisfy &block"
    end
  end
end
