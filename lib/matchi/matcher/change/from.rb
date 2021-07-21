# frozen_string_literal: true

require_relative File.join("from", "to")

module Matchi
  module Matcher
    class Change
      # *Change from to* wrapper.
      class From
        # Initialize the matcher with an object.
        #
        # @example The change from "foo" to "FOO" matcher.
        #   object = "foo"
        #   Matchi::Matcher::Change::From.new("foo").to("FOO") { object.to_s }
        #
        # @param expected [#object_id]  An expected initial value.
        # @param state    [Proc]        A block of code to execute to get the
        #   state of the object.
        def initialize(expected, &state)
          @expected = expected
          @state    = state
        end

        # Specifies the new value to expect.
        #
        # @param expected_new_value [#object_id] The new value to expect.
        #
        # @return [#matches?] A *change from to* matcher.
        def to(expected_new_value)
          To.new(@expected, expected_new_value, &@state)
        end
      end
    end
  end
end
