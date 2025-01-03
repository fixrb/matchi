# frozen_string_literal: true

module Matchi
  class Change
    class From
      # *Change from to* matcher.
      class To
        # Initialize the matcher with two objects and a block.
        #
        # @example
        #   require "matchi/change/from/to"
        #
        #   object = "foo"
        #
        #   Matchi::Change::From::To.new("foo", "FOO") { object.to_s }
        #
        # @param expected_init      [#object_id] An expected initial value.
        # @param expected_new_value [#object_id] An expected new value.
        # @param state              [Proc]       A block of code to execute to
        #   get the state of the object.
        def initialize(expected_init, expected_new_value, &state)
          raise ::ArgumentError, "a block must be provided" unless block_given?

          @expected_init  = expected_init
          @expected       = expected_new_value
          @state          = state
        end

        # Boolean comparison on the expected change by comparing the value
        # before and after the code execution.
        #
        # @example
        #   require "matchi/change/from/to"
        #
        #   object = "foo"
        #
        #   matcher = Matchi::Change::From::To.new("foo", "FOO") { object.to_s }
        #   matcher.match? { object.upcase! } # => true
        #
        # @yieldreturn [#object_id] The block of code to execute.
        #
        # @return [Boolean] Comparison between the value before and after the
        #   code execution.
        def match?
          raise ::ArgumentError, "a block must be provided" unless block_given?

          value_before = @state.call
          return false unless @expected_init == value_before

          yield
          value_after = @state.call

          @expected == value_after
        end

        # Returns a string representing the matcher.
        #
        # @return [String] a human-readable description of the matcher
        def to_s
          "change from #{@expected_init.inspect} to #{@expected.inspect}"
        end
      end
    end
  end
end
