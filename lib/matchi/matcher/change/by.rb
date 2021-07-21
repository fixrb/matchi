# frozen_string_literal: true

require_relative File.join("..", "base")

module Matchi
  module Matcher
    class Change
      # *Change by* matcher.
      class By < ::Matchi::Matcher::Base
        # Returns a symbol identifying the matcher.
        def self.to_sym
          :change
        end

        # Initialize the matcher with an object.
        #
        # @example The change by 1 matcher.
        #   object = []
        #   Matchi::Matcher::Change::By.new(1) { object.length }
        #
        # @param expected [#object_id]  An expected delta.
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
        #   object = []
        #   change = Matchi::Matcher::Change::By.new(1) { object.length }
        #   change.matches? { object << "foo" } # => true
        #
        # @yieldreturn [#object_id] The block of code to execute.
        #
        # @return [Boolean] Comparison between the value before and after the
        #   code execution.
        def matches?(*, **)
          value_before = @state.call
          yield
          value_after = @state.call

          expected == (value_after - value_before)
        end

        # (see Base#to_s)
        def to_s
          "change by #{expected.inspect}"
        end
      end
    end
  end
end
