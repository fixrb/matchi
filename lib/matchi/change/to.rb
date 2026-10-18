# frozen_string_literal: true

require_relative "../eq"

module Matchi
  class Change
    # Passes when the observed value is not the expected value before the
    # block and is the expected value after it: the value must change to it.
    # The block is always evaluated.
    #
    # @example
    #   s = +"a"
    #   Matchi::Change.new(s, :to_s).to("b").match? { s.replace("b") } # => true
    class To
      # @param expected [#eql?] the expected value after the block
      # @yieldreturn [Object] the observed value
      # @raise [ArgumentError] when no block is given
      def initialize(expected, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state = state
      end

      # @yieldreturn [Object] ignored, the block is evaluated for its effect
      # @return [Boolean]
      # @raise [ArgumentError] when no block is given
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        already = Eq.eql?(@expected, @state.call)
        yield

        !already && Eq.eql?(@expected, @state.call)
      end

      # @return [String]
      def to_s
        "change to #{@expected.inspect}"
      end
    end
  end
end
