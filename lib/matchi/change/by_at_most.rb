# frozen_string_literal: true

module Matchi
  class Change
    # Maximum delta matcher that verifies numeric changes don't exceed a limit.
    #
    # This matcher ensures that a numeric value changes by no more than the specified amount
    # after executing a block of code. It's particularly useful when testing operations
    # where you want to enforce an upper bound on changes, such as rate limiting,
    # resource consumption, or controlled increments.
    #
    # @example Testing controlled collection growth
    #   items = []
    #   matcher = Matchi::Change::ByAtMost.new(2) { items.size }
    #   matcher.match? { items.push(1) }             # => true   # Changed by less than limit
    #   matcher.match? { items.push(1, 2) }          # => true   # Changed by exactly limit
    #   matcher.match? { items.push(1, 2, 3) }       # => false  # Changed by more than limit
    #
    # @example Rate limiting
    #   class RateLimiter
    #     def initialize
    #       @requests = 0
    #     end
    #
    #     def process_batch(items)
    #       items.each do |item|
    #         break if @requests >= 3  # Rate limit
    #         process_item(item)
    #       end
    #     end
    #
    #     private
    #
    #     def process_item(item)
    #       @requests += 1
    #       # Processing logic...
    #     end
    #
    #     def requests
    #       @requests
    #     end
    #   end
    #
    #   limiter = RateLimiter.new
    #   matcher = Matchi::Change::ByAtMost.new(3) { limiter.requests }
    #   matcher.match? { limiter.process_batch([1, 2, 3, 4, 5]) } # => true
    #
    # @example Resource consumption
    #   class ResourcePool
    #     attr_reader :used
    #
    #     def initialize
    #       @used = 0
    #     end
    #
    #     def allocate(requested)
    #       available = 5 - @used  # Maximum pool size is 5
    #       granted = [requested, available].min
    #       @used += granted
    #       granted
    #     end
    #   end
    #
    #   pool = ResourcePool.new
    #   matcher = Matchi::Change::ByAtMost.new(2) { pool.used }
    #   matcher.match? { pool.allocate(2) }  # => true
    #   matcher.match? { pool.allocate(3) }  # => false
    #
    # @example Score adjustments
    #   class GameScore
    #     attr_reader :value
    #
    #     def initialize
    #       @value = 100
    #     end
    #
    #     def apply_penalty(amount)
    #       max_penalty = 10
    #       actual_penalty = [amount, max_penalty].min
    #       @value -= actual_penalty
    #     end
    #   end
    #
    #   score = GameScore.new
    #   matcher = Matchi::Change::ByAtMost.new(10) { -score.value }
    #   matcher.match? { score.apply_penalty(5) }   # => true   # Small penalty
    #   matcher.match? { score.apply_penalty(15) }  # => true   # Limited to max
    #
    # @note This matcher verifies maximum changes only. For exact changes, use By,
    #   and for minimum changes, use ByAtLeast.
    #
    # @see Matchi::Change::By For exact change validation
    # @see Matchi::Change::ByAtLeast For minimum change validation
    # @see Matchi::Change::To For final value validation
    class ByAtMost
      # Initialize the matcher with a maximum allowed change and a state block.
      #
      # @api public
      #
      # @param expected [Numeric] The maximum amount by which the value should change
      # @param state [Proc] Block that retrieves the current value
      #
      # @raise [ArgumentError] if expected is not a Numeric
      # @raise [ArgumentError] if expected is negative
      # @raise [ArgumentError] if no state block is provided
      #
      # @return [ByAtMost] a new instance of the matcher
      #
      # @example With integer maximum
      #   ByAtMost.new(5) { counter.value }
      #
      # @example With floating point maximum
      #   ByAtMost.new(0.5) { temperature.celsius }
      def initialize(expected, &state)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "a block must be provided" unless block_given?
        raise ::ArgumentError, "expected must be non-negative" if expected.negative?

        @expected = expected
        @state = state
      end

      # Checks if the value changes by no more than the expected amount.
      #
      # This method compares the value before and after executing the provided block,
      # ensuring that the absolute difference is less than or equal to the expected maximum.
      # This is useful for enforcing upper bounds on state changes.
      #
      # @api public
      #
      # @yield [] Block that should cause the state change
      # @yieldreturn [Object] The result of the block (not used)
      #
      # @return [Boolean] true if the value changed by at most the expected amount
      #
      # @raise [ArgumentError] if no block is provided
      #
      # @example Basic usage with growth
      #   users = []
      #   matcher = ByAtMost.new(2) { users.size }
      #   matcher.match? { users.push('alice') }  # => true
      #
      # @example With negative changes
      #   stock = 10
      #   matcher = ByAtMost.new(3) { stock }
      #   matcher.match? { stock -= 2 }  # => true
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        value_before = @state.call
        yield
        value_after = @state.call

        @expected >= (value_after - value_before)
      end

      # Returns a human-readable description of the matcher.
      #
      # @api public
      #
      # @return [String] A string describing what this matcher verifies
      #
      # @example
      #   ByAtMost.new(5).to_s    # => "change by at most 5"
      #   ByAtMost.new(2.5).to_s  # => "change by at most 2.5"
      def to_s
        "change by at most #{@expected.inspect}"
      end
    end
  end
end
