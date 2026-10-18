# frozen_string_literal: true

require_relative "../number"

module Matchi
  class Change
    # Passes when the difference between the observed value after and before
    # the block, `after - before`, is exactly the expected delta (`:by`), at
    # least it (`:by_at_least`) or at most it (`:by_at_most`). The expected
    # delta receives the comparison; the difference is computed by the
    # observed values, so this matcher depends on their honesty.
    #
    # @example
    #   list = []
    #   Matchi::Change::Delta.new(:by, 2) { list.length }.match? { list.push(1, 2) } # => true
    class Delta
      # For each kind: the comparison the delta receives, and its description.
      KINDS = {
        by:          [:==, "by"],
        by_at_least: [:<=, "by at least"],
        by_at_most:  [:>=, "by at most"]
      }.freeze

      # @param kind [Symbol] `:by`, `:by_at_least` or `:by_at_most`
      # @param delta [Numeric] a finite real number, non-negative unless kind is `:by`
      # @yieldreturn [Object] the observed value
      # @raise [ArgumentError] when the kind is unknown, delta is not such a number, or no block is given
      def initialize(kind, delta, &state)
        raise ::ArgumentError, "unknown kind #{kind.inspect}" unless KINDS.key?(kind)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @operator, @label = KINDS.fetch(kind)
        @delta = kind == :by ? Number.finite_real!(delta, "delta") : Number.non_negative!(delta, "delta")
        @state = state
      end

      # @yieldreturn [Object] ignored, the block is evaluated for its effect
      # @return [Boolean]
      # @raise [ArgumentError] when no block is given
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        value_before = @state.call
        yield
        value_after = @state.call

        @delta.public_send(@operator, value_after - value_before) ? true : false
      end

      # @return [String]
      def to_s
        "change #{@label} #{@delta.inspect}"
      end
    end
  end
end
