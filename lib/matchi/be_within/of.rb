# frozen_string_literal: true

module Matchi
  class BeWithin
    # *BeWithin of* matcher.
    class Of
      # Initialize the matcher with a delta and an expected value.
      #
      # @example
      #   require "matchi/be_within/of"
      #
      #   Matchi::BeWithin::Of.new(1, 41)
      #
      # @param delta    [Numeric] The accepted variation of the actual value.
      # @param expected [Numeric] The expected value.
      def initialize(delta, expected)
        raise ::ArgumentError, "delta must be a Numeric" unless delta.is_a?(::Numeric)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "delta must be non-negative" if delta.negative?

        @delta    = delta
        @expected = expected
      end

      # Boolean comparison on the expected be_within by comparing the actual
      # value and the expected value.
      #
      # @example
      #   require "matchi/be_within/of"
      #
      #   matcher = Matchi::BeWithin::Of.new(1, 41)
      #   matcher.match? { 42 } # => true
      #
      # @yieldreturn [Numeric] The block of code to execute.
      #
      # @return [Boolean] Comparison between the actual and the expected values.
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        (@expected - yield).abs <= @delta
      end

      # Returns a string representing the matcher.
      #
      # @return [String] a human-readable description of the matcher
      def to_s
        "be within #{@delta} of #{@expected}"
      end
    end
  end
end
