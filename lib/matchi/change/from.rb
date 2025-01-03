# frozen_string_literal: true

require_relative File.join("from", "to")

module Matchi
  class Change
    # *Change from to* wrapper.
    class From
      # Initialize the wrapper with an object and a block.
      #
      # @example
      #   require "matchi/change/from"
      #
      #   object = "foo"
      #
      #   Matchi::Change::From.new("foo") { object.to_s }
      #
      # @param expected [#object_id]  An expected initial value.
      # @param state    [Proc]        A block of code to execute to get the
      #   state of the object.
      def initialize(expected, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state    = state
      end

      # Specifies the new value to expect.
      #
      # @example
      #   require "matchi/change/from"
      #
      #   object = "foo"
      #
      #   change_from_wrapper = Matchi::Change::From.new("foo") { object.to_s }
      #   change_from_wrapper.to("FOO")
      #
      # @param expected_new_value [#object_id] The new value to expect.
      #
      # @return [#match?] A *change from to* matcher.
      def to(expected_new_value)
        To.new(@expected, expected_new_value, &@state)
      end
    end
  end
end
