# frozen_string_literal: true

module Matchi
  class Change
    # Final state matcher that verifies if a method returns an expected value after a change.
    #
    # This matcher focuses on the final state of an object, verifying that a method call
    # returns an expected value after executing a block of code. Unlike the full from/to
    # matcher, it only cares about the end result, not the initial state.
    #
    # @example Basic string transformation
    #   text = "hello"
    #   matcher = Matchi::Change::To.new("HELLO") { text.to_s }
    #   matcher.match? { text.upcase! }   # => true
    #   matcher.match? { text.reverse! }  # => false
    #
    # @example Number calculations
    #   counter = 0
    #   matcher = Matchi::Change::To.new(5) { counter }
    #   matcher.match? { counter = 5 }    # => true
    #   matcher.match? { counter += 1 }   # => false
    #
    # @example With object attributes
    #   class User
    #     attr_accessor :status
    #     def initialize(status)
    #       @status = status
    #     end
    #   end
    #
    #   user = User.new(:pending)
    #   matcher = Matchi::Change::To.new(:active) { user.status }
    #   matcher.match? { user.status = :active }  # => true
    #
    # @see Matchi::Change::From::To For checking both initial and final states
    # @see Matchi::Change::By For checking numeric changes
    class To
      # Initialize the matcher with an expected new value and a state block.
      #
      # @api public
      #
      # @param expected [#eql?] The expected final value
      # @param state [Proc] Block that retrieves the value to check
      #
      # @raise [ArgumentError] if no state block is provided
      #
      # @return [To] a new instance of the matcher
      #
      # @example With simple value
      #   To.new("test") { object.value }
      #
      # @example With complex calculation
      #   To.new(100) { object.items.count }
      def initialize(expected, &state)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state = state
      end

      # Checks if the state block returns the expected value after executing the provided block.
      #
      # This method executes the provided block and then checks if the state block
      # returns the expected value. It only cares about the final state, not any
      # intermediate values or the initial state.
      #
      # @api public
      #
      # @yield [] Block that should cause the state change
      # @yieldreturn [Object] The result of the block (not used)
      #
      # @return [Boolean] true if the final state matches the expected value
      #
      # @raise [ArgumentError] if no block is provided
      #
      # @example Basic usage
      #   text = "hello"
      #   matcher = To.new("HELLO") { text.to_s }
      #   matcher.match? { text.upcase! }  # => true
      #
      # @example With method chaining
      #   array = [1, 2, 3]
      #   matcher = To.new(6) { array.sum }
      #   matcher.match? { array.map! { |x| x * 2 } }  # => false
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        yield
        value_after = @state.call

        @expected.eql?(value_after)
      end

      # Returns a human-readable description of the matcher.
      #
      # @api public
      #
      # @return [String] A string describing what this matcher verifies
      #
      # @example
      #   To.new("test").to_s # => 'change to "test"'
      def to_s
        "change to #{@expected.inspect}"
      end
    end
  end
end
