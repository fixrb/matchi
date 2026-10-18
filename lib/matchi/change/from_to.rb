# frozen_string_literal: true

require_relative "../eq"

module Matchi
  class Change
    # Passes when the observed value is the old value before the block and
    # the new value after it, both compared like {Matchi::Eq}. The block is
    # always evaluated; a wrong initial value is a failure of the
    # expectation, like a wrong final value.
    #
    # @example
    #   s = +"a"
    #   Matchi::Change.new(s, :to_s).from("a").to("b").match? { s.replace("b") } # => true
    class FromTo
      # @param old_value [#eql?] the expected value before the block
      # @param new_value [#eql?] the expected value after the block
      # @yieldreturn [Object] the observed value
      # @raise [ArgumentError] when no block is given
      def initialize(old_value, new_value, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @old_value = old_value
        @new_value = new_value
        @state = state
      end

      # @yieldreturn [Object] ignored, the block is evaluated for its effect
      # @return [Boolean]
      # @raise [ArgumentError] when no block is given
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        initial = Eq.eql?(@old_value, @state.call)
        yield

        initial && Eq.eql?(@new_value, @state.call)
      end

      # @return [String]
      def to_s
        "change from #{@old_value.inspect} to #{@new_value.inspect}"
      end
    end
  end
end
