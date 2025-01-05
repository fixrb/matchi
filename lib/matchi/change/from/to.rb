# frozen_string_literal: true

module Matchi
  class Change
    class From
      # Value transition matcher that verifies both initial and final states of an operation.
      #
      # This matcher ensures that a value not only changes to an expected final state but also
      # starts from a specific initial state. This is particularly useful when testing state
      # transitions where both the starting and ending conditions are important, such as in
      # workflow systems, state machines, or data transformations.
      #
      # @example Basic string transformation
      #   text = "hello"
      #   matcher = Matchi::Change::From::To.new("hello", "HELLO") { text.to_s }
      #   matcher.match? { text.upcase! }   # => true
      #   matcher.match? { text.reverse! }  # => false  # Wrong final state
      #
      #   text = "other"
      #   matcher.match? { text.upcase! }   # => false  # Wrong initial state
      #
      # @example State machine transitions
      #   class Order
      #     attr_accessor :status
      #     def initialize(status)
      #       @status = status
      #     end
      #   end
      #
      #   order = Order.new(:pending)
      #   matcher = Matchi::Change::From::To.new(:pending, :shipped) { order.status }
      #   matcher.match? { order.status = :shipped }  # => true
      #
      # @example Complex object transformations
      #   class User
      #     attr_accessor :permissions
      #     def initialize
      #       @permissions = [:read]
      #     end
      #
      #     def promote!
      #       @permissions += [:write, :delete]
      #     end
      #   end
      #
      #   user = User.new
      #   matcher = Matchi::Change::From::To.new(
      #     [:read],
      #     [:read, :write, :delete]
      #   ) { user.permissions }
      #   matcher.match? { user.promote! }  # => true
      #
      # @see Matchi::Change::To For checking only the final state
      # @see Matchi::Change::By For checking numeric changes
      class To
        # Initialize the matcher with expected initial and final values.
        #
        # @api public
        #
        # @param expected_init [#==] The expected initial value
        # @param expected_new_value [#==] The expected final value
        # @param state [Proc] Block that retrieves the current value
        #
        # @raise [ArgumentError] if no state block is provided
        #
        # @return [To] a new instance of the matcher
        #
        # @example With simple value
        #   To.new("draft", "published") { document.status }
        #
        # @example With complex state
        #   To.new([:user], [:user, :admin]) { account.roles }
        def initialize(expected_init, expected_new_value, &state)
          raise ::ArgumentError, "a block must be provided" unless block_given?

          @expected_init = expected_init
          @expected = expected_new_value
          @state = state
        end

        # Verifies both initial and final states during a transition.
        #
        # This method first checks if the initial state matches the expected value,
        # then executes the provided block and verifies the final state. The match
        # fails if either the initial or final state doesn't match expectations.
        #
        # @api public
        #
        # @yield [] Block that should cause the state transition
        # @yieldreturn [Object] The result of the block (not used)
        #
        # @return [Boolean] true if both initial and final states match expectations
        #
        # @raise [ArgumentError] if no block is provided
        #
        # @example Basic usage
        #   text = "hello"
        #   matcher = To.new("hello", "HELLO") { text }
        #   matcher.match? { text.upcase! }  # => true
        #
        # @example Failed initial state
        #   text = "wrong"
        #   matcher = To.new("hello", "HELLO") { text }
        #   matcher.match? { text.upcase! }  # => false
        def match?
          raise ::ArgumentError, "a block must be provided" unless block_given?

          value_before = @state.call
          return false unless @expected_init == value_before

          yield
          value_after = @state.call

          @expected == value_after
        end

        # Returns a human-readable description of the matcher.
        #
        # @api public
        #
        # @return [String] A string describing what this matcher verifies
        #
        # @example
        #   To.new("draft", "published").to_s
        #   # => 'change from "draft" to "published"'
        def to_s
          "change from #{@expected_init.inspect} to #{@expected.inspect}"
        end
      end
    end
  end
end
