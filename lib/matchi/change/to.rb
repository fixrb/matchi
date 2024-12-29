# frozen_string_literal: true

module Matchi
  class Change
    # *Change to* matcher.
    class To
      # Initialize the matcher with an object and a block.
      #
      # @example
      #   require "matchi/change/to"
      #
      #   object = "foo"
      #
      #   Matchi::Change::To.new("FOO") { object.to_s }
      #
      # @param expected [#object_id]  An expected new value.
      # @param state    [Proc]        A block of code to execute to get the
      #   state of the object.
      def initialize(expected, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state    = state
      end

      # Boolean comparison on the expected change by comparing the value
      # before and after the code execution.
      #
      # @example
      #   require "matchi/change/to"
      #
      #   object = "foo"
      #
      #   matcher = Matchi::Change::To.new("FOO") { object.to_s }
      #   matcher.match? { object.upcase! } # => true
      #
      # @yieldreturn [#object_id] The block of code to execute.
      #
      # @return [Boolean] Comparison between the value before and after the
      #   code execution.
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        yield
        value_after = @state.call

        @expected == value_after
      end

      # Returns a string representing the matcher.
      #
      # @return [String] a human-readable description of the matcher
      def to_s
        "change to #{@expected.inspect}"
      end
    end
  end
end
