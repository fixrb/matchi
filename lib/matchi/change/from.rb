# frozen_string_literal: true

require_relative File.join("from", "to")

module Matchi
  class Change
    # Initial state wrapper for building a value transition matcher.
    #
    # This class acts as a wrapper that captures the expected initial state and
    # provides methods to build a complete transition matcher. When combined with
    # the 'to' method, it creates a matcher that verifies both the starting and
    # ending values of a change operation. This is useful when you need to ensure
    # not only the final state but also the initial state of a value.
    #
    # @example Basic string transformation
    #   text = "hello"
    #   Change.new(text, :to_s).from("hello").to("HELLO").match? { text.upcase! }  # => true
    #
    # @example Object state transition
    #   class User
    #     attr_accessor :status
    #     def initialize
    #       @status = "pending"
    #     end
    #   end
    #
    #   user = User.new
    #   Change.new(user, :status).from("pending").to("active").match? {
    #     user.status = "active"
    #   }  # => true
    #
    # @see Matchi::Change::From::To For the complete transition matcher
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
      # Creates a complete transition matcher that verifies both the initial
      # and final states of a value. The matcher will succeed only if the
      # value starts at the expected initial state and changes to the specified
      # new value after executing the test block.
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
