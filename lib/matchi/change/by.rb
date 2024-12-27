# frozen_string_literal: true

module Matchi
  class Change
    # *Change by* matcher.
    class By
      # Initialize the matcher with an object and a block.
      #
      # @example
      #   require "matchi/change/by"
      #
      #   object = []
      #
      #   Matchi::Change::By.new(1) { object.length }
      #
      # @param expected [#object_id]  An expected delta.
      # @param state    [Proc]        A block of code to execute to get the
      #   state of the object.
      def initialize(expected, &state)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state    = state
      end

      # Boolean comparison on the expected change by comparing the value
      # before and after the code execution.
      #
      # @example
      #   require "matchi/change/by"
      #
      #   object = []
      #
      #   matcher = Matchi::Change::By.new(1) { object.length }
      #   matcher.match? { object << "foo" } # => true
      #
      # @yieldreturn [#object_id] The block of code to execute.
      #
      # @return [Boolean] Comparison between the value before and after the
      #   code execution.
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        value_before = @state.call
        yield
        value_after = @state.call

        @expected == (value_after - value_before)
      end

      # A string containing a human-readable representation of the matcher.
      def inspect
        "#{self.class}(#{@expected.inspect})"
      end

      # Returns a string representing the matcher.
      def to_s
        "change by #{@expected.inspect}"
      end
    end
  end
end
