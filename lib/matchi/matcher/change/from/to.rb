# frozen_string_literal: true

require_relative File.join("..", "..", "base")

module Matchi
  module Matcher
    class Change
      class From
        # *Change from to* matcher.
        class To < ::Matchi::Matcher::Base
          # Returns a symbol identifying the matcher.
          def self.to_sym
            :change
          end

          # Initialize the matcher with an object.
          #
          # @example The change from "foo" to "FOO" matcher.
          #   object = "foo"
          #   Matchi::Matcher::Change::From::To.new("foo", "FOO") { object.to_s }
          #
          # @param expected_init      [#object_id] An expected initial value.
          # @param expected_new_value [#object_id] An expected new value.
          # @param state              [Proc]       A block of code to execute to
          #   get the state of the object.
          def initialize(expected_init, expected_new_value, &state)
            super()
            @expected_init  = expected_init
            @expected       = expected_new_value
            @state          = state
          end

          # (see Base#inspect)
          def inspect
            "Matchi::Matcher::Change::From(#{@expected_init.inspect})::To(#{expected.inspect})"
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
            value_before = @state.call
            return false unless @expected_init == value_before

            yield
            value_after = @state.call

            expected == value_after
          end

          # (see Base#to_s)
          def to_s
            "change from #{@expected_init.inspect} to #{expected.inspect}"
          end
        end
      end
    end
  end
end
