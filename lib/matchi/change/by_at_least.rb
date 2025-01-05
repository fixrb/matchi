# frozen_string_literal: true

module Matchi
  class Change
    # Minimum delta matcher that verifies numeric changes meet or exceed a threshold.
    #
    # This matcher ensures that a numeric value changes by at least the specified amount
    # after executing a block of code. It's particularly useful when testing operations
    # where you want to ensure a minimum change occurs but larger changes are acceptable,
    # such as performance improvements, resource allocation, or progressive counters.
    #
    # @example Testing collection growth
    #   items = []
    #   matcher = Matchi::Change::ByAtLeast.new(2) { items.size }
    #   matcher.match? { items.push(1, 2) }          # => true   # Changed by exactly 2
    #   matcher.match? { items.push(1, 2, 3) }       # => true   # Changed by more than 2
    #   matcher.match? { items.push(1) }             # => false  # Changed by less than 2
    #
    # @example Verifying performance improvements
    #   class Benchmark
    #     def initialize
    #       @score = 100
    #     end
    #
    #     def optimize!
    #       @score += rand(20..30)  # Improvement varies
    #     end
    #
    #     def score
    #       @score
    #     end
    #   end
    #
    #   benchmark = Benchmark.new
    #   matcher = Matchi::Change::ByAtLeast.new(20) { benchmark.score }
    #   matcher.match? { benchmark.optimize! }   # => true  # Any improvement >= 20 passes
    #
    # @example Resource allocation
    #   class Pool
    #     def initialize
    #       @capacity = 1000
    #     end
    #
    #     def allocate(minimum, maximum)
    #       actual = rand(minimum..maximum)
    #       @capacity -= actual
    #       actual
    #     end
    #
    #     def available
    #       @capacity
    #     end
    #   end
    #
    #   pool = Pool.new
    #   matcher = Matchi::Change::ByAtLeast.new(50) { -pool.available }
    #   matcher.match? { pool.allocate(50, 100) }  # => true  # Allocates at least 50
    #
    # @example Price threshold monitoring
    #   class Stock
    #     attr_reader :price
    #
    #     def initialize(price)
    #       @price = price
    #     end
    #
    #     def fluctuate!
    #       @price += rand(-10.0..20.0)
    #     end
    #   end
    #
    #   stock = Stock.new(100.0)
    #   matcher = Matchi::Change::ByAtLeast.new(10.0) { stock.price }
    #   matcher.match? { stock.fluctuate! }  # => true if price rises by 10.0 or more
    #
    # @note This matcher verifies minimum changes only. For exact changes, use By,
    #   and for maximum changes, use ByAtMost.
    #
    # @see Matchi::Change::By For exact change validation
    # @see Matchi::Change::ByAtMost For maximum change validation
    # @see Matchi::Change::To For final value validation
    class ByAtLeast
      # Initialize the matcher with a minimum expected change and a state block.
      #
      # @api public
      #
      # @param expected [Numeric] The minimum amount by which the value should change
      # @param state [Proc] Block that retrieves the current value
      #
      # @raise [ArgumentError] if expected is not a Numeric
      # @raise [ArgumentError] if expected is negative
      # @raise [ArgumentError] if no state block is provided
      #
      # @return [ByAtLeast] a new instance of the matcher
      #
      # @example With integer minimum
      #   ByAtLeast.new(5) { counter.value }
      #
      # @example With floating point minimum
      #   ByAtLeast.new(0.5) { temperature.celsius }
      def initialize(expected, &state)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "a block must be provided" unless block_given?
        raise ::ArgumentError, "expected must be non-negative" if expected.negative?

        @expected = expected
        @state    = state
      end

      # Checks if the value changes by at least the expected amount.
      #
      # This method compares the value before and after executing the provided block,
      # ensuring that the difference is greater than or equal to the expected minimum.
      # This is useful when you want to verify that a change meets a minimum threshold.
      #
      # @api public
      #
      # @yield [] Block that should cause the state change
      # @yieldreturn [Object] The result of the block (not used)
      #
      # @return [Boolean] true if the value changed by at least the expected amount
      #
      # @raise [ArgumentError] if no block is provided
      #
      # @example Basic usage
      #   counter = 0
      #   matcher = ByAtLeast.new(5) { counter }
      #   matcher.match? { counter += 7 }  # => true   # Changed by more than minimum
      #
      # @example Edge case - exact minimum
      #   items = []
      #   matcher = ByAtLeast.new(2) { items.size }
      #   matcher.match? { items.push(1, 2) }  # => true  # Changed by exactly minimum
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        value_before = @state.call
        yield
        value_after = @state.call

        @expected <= (value_after - value_before)
      end

      # Returns a human-readable description of the matcher.
      #
      # @api public
      #
      # @return [String] A string describing what this matcher verifies
      #
      # @example
      #   ByAtLeast.new(5).to_s    # => "change by at least 5"
      #   ByAtLeast.new(2.5).to_s  # => "change by at least 2.5"
      def to_s
        "change by at least #{@expected.inspect}"
      end
    end
  end
end
