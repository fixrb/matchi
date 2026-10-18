# frozen_string_literal: true

require_relative "from_to"

module Matchi
  class Change
    # Builder for the `change from OLD to NEW` matcher. It is not a matcher
    # itself: it does not respond to `match?`, so a forgotten `to` is rejected
    # by any framework that checks the matcher interface.
    #
    # @example
    #   Matchi::Change.new(s, :to_s).from("a").to("b")
    class From
      # @param old_value [#eql?] the expected value before the block
      # @yieldreturn [Object] the observed value
      # @raise [ArgumentError] when no block is given
      def initialize(old_value, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @old_value = old_value
        @state = state
      end

      # @param new_value [#eql?] the expected value after the block
      # @return [Matchi::Change::FromTo]
      def to(new_value)
        FromTo.new(@old_value, new_value, &@state)
      end

      # @return [String]
      def to_s
        "change from #{@old_value.inspect}"
      end
    end
  end
end
