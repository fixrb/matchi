# frozen_string_literal: true

module Matchi
  class Change
    # Exact delta matcher that verifies precise numeric changes in object state.
    #
    # This matcher ensures that a numeric value changes by exactly the specified amount
    # after executing a block of code. It's particularly useful for testing operations
    # that should produce precise, predictable changes in numeric attributes, such as
    # counters, quantities, or calculated values.
    #
    # @example Testing collection size changes
    #   array = []
    #   matcher = Matchi::Change::By.new(2) { array.size }
    #   matcher.match? { array.concat([1, 2]) }     # => true
    #   matcher.match? { array.push(3) }            # => false  # Changed by 1
    #   matcher.match? { array.push(3, 4, 5) }      # => false  # Changed by 3
    #
    # @example Verifying numeric calculations
    #   counter = 100
    #   matcher = Matchi::Change::By.new(-10) { counter }
    #   matcher.match? { counter -= 10 }            # => true
    #   matcher.match? { counter -= 15 }            # => false  # Changed too much
    #
    # @example Working with custom numeric attributes
    #   class Account
    #     attr_reader :balance
    #
    #     def initialize(initial_balance)
    #       @balance = initial_balance
    #     end
    #
    #     def deposit(amount)
    #       @balance += amount
    #     end
    #
    #     def withdraw(amount)
    #       @balance -= amount
    #     end
    #   end
    #
    #   account = Account.new(1000)
    #   matcher = Matchi::Change::By.new(50) { account.balance }
    #   matcher.match? { account.deposit(50) }      # => true
    #   matcher.match? { account.deposit(75) }      # => false  # Changed by 75
    #
    # @example Handling floating point values
    #   temperature = 20.0
    #   matcher = Matchi::Change::By.new(1.5) { temperature }
    #   matcher.match? { temperature += 1.5 }       # => true
    #   matcher.match? { temperature += 1.6 }       # => false  # Not exact match
    #
    # @note This matcher checks for exact changes, use ByAtLeast or ByAtMost for
    #   more flexible delta comparisons
    #
    # @see Matchi::Change::ByAtLeast For minimum change validation
    # @see Matchi::Change::ByAtMost For maximum change validation
    # @see Matchi::Change::From::To For exact value transition validation
    class By
      # Initialize the matcher with an expected delta and a state block.
      #
      # @api public
      #
      # @param expected [Numeric] The exact amount by which the value should change
      # @param state [Proc] Block that retrieves the current value
      #
      # @raise [ArgumentError] if expected is not a Numeric
      # @raise [ArgumentError] if no state block is provided
      #
      # @return [By] a new instance of the matcher
      #
      # @example With positive delta
      #   By.new(5) { counter.value }
      #
      # @example With negative delta
      #   By.new(-3) { stock_level.quantity }
      #
      # @example With floating point delta
      #   By.new(0.5) { temperature.celsius }
      def initialize(expected, &state)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "a block must be provided" unless block_given?

        @expected = expected
        @state = state
      end

      # Verifies that the value changes by exactly the expected amount.
      #
      # This method compares the value before and after executing the provided block,
      # ensuring that the difference matches the expected delta exactly. It's useful
      # for cases where precision is important and approximate changes are not acceptable.
      #
      # @api public
      #
      # @yield [] Block that should cause the state change
      # @yieldreturn [Object] The result of the block (not used)
      #
      # @return [Boolean] true if the value changed by exactly the expected amount
      #
      # @raise [ArgumentError] if no block is provided
      #
      # @example Basic usage
      #   counter = 0
      #   matcher = By.new(5) { counter }
      #   matcher.match? { counter += 5 }  # => true
      #
      # @example Failed match
      #   items = []
      #   matcher = By.new(2) { items.size }
      #   matcher.match? { items.push(1) }  # => false  # Changed by 1
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        value_before = @state.call
        yield
        value_after = @state.call

        @expected == (value_after - value_before)
      end

      # Returns a human-readable description of the matcher.
      #
      # @api public
      #
      # @return [String] A string describing what this matcher verifies
      #
      # @example
      #   By.new(5).to_s    # => "change by 5"
      #   By.new(-3).to_s   # => "change by -3"
      #   By.new(2.5).to_s  # => "change by 2.5"
      def to_s
        "change by #{@expected.inspect}"
      end
    end
  end
end
