# frozen_string_literal: true

require_relative File.join("..", "base")

module Matchi
  module Matcher
    class Change
      # *Change to* matcher.
      class To < ::Matchi::Matcher::Base
        # Returns a symbol identifying the matcher.
        def self.to_sym
          :change
        end

        # Initialize the matcher with an object.
        #
        # @example The change to "FOO" matcher.
        #   object = "foo"
        #   Matchi::Matcher::Change::To.new("FOO") { object.to_s }
        #
        # @param expected [#object_id]  An expected result value.
        # @param state    [Proc]        A block of code to execute to get the
        #   state of the object.
        def initialize(expected, &state)
          super()
          @expected = expected
          @state    = state
        end

        # Boolean comparison on the expected change by comparing the value
        # before and after the code execution.
        #
        # @example
        #   object = "foo"
        #   change = Matchi::Matcher::Change::To.new("FOO") { object.to_s }
        #   change.matches? { object.upcase! } # => true
        #
        # @yieldreturn [#object_id] The block of code to execute.
        #
        # @return [Boolean] Comparison between the value before and after the
        #   code execution.
        def matches?(*, **)
          yield
          value_after = @state.call

          expected == value_after
        end

        # (see Base#to_s)
        def to_s
          "change to #{expected.inspect}"
        end
      end
    end
  end
end
