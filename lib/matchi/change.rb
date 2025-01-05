# frozen_string_literal: true

require_relative File.join("change", "by_at_least")
require_relative File.join("change", "by_at_most")
require_relative File.join("change", "by")
require_relative File.join("change", "from")
require_relative File.join("change", "to")

module Matchi
  # Wraps the target of a change matcher.
  class Change
    # Initialize a wrapper of the change matcher with an object and the name of
    # one of its methods.
    #
    # @api public
    #
    # @param object [#object_id] The object whose state will be monitored
    # @param method [Symbol] The name of the method to track
    # @param args [Array] Additional positional arguments to pass to the method
    # @param kwargs [Hash] Additional keyword arguments to pass to the method
    # @param block [Proc] Optional block to pass to the method
    #
    # @raise [ArgumentError] if method is not a Symbol
    # @raise [ArgumentError] if object doesn't respond to method
    #
    # @return [Change] a new instance of the change wrapper
    #
    # @example Basic initialization
    #   array = []
    #   Change.new(array, :length)              # Track array length changes
    #
    # @example With positional arguments
    #   hash = { key: "value" }
    #   Change.new(hash, :fetch, :key)          # Track specific key value
    #
    # @example With keyword arguments
    #   hash = { a: 1, b: 2 }
    #   Change.new(hash, :fetch, default: 0)    # Track with default value
    #
    # @example With block
    #   hash = { a: 1 }
    #   Change.new(hash, :fetch, :b) { |k| k.to_s }  # Track with block default
    def initialize(object, method, *args, **kwargs, &block)
      raise ::ArgumentError, "method must be a Symbol" unless method.is_a?(::Symbol)
      raise ::ArgumentError, "object must respond to method" unless object.respond_to?(method)

      @state = -> { object.send(method, *args, **kwargs, &block) }
    end

    # Checks if the tracked method's return value changes when executing the block.
    #
    # This method verifies that the value changes in any way between the start and end
    # of the block execution. It doesn't care about the type or magnitude of the change,
    # only that it's different.
    #
    # @api public
    #
    # @yield [] Block during which the change should occur
    # @yieldreturn [Object] Result of the block execution (not used)
    #
    # @return [Boolean] true if the value changed, false otherwise
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @example Basic usage with array length
    #   array = []
    #   matcher = Change.new(array, :length)
    #   matcher.match? { array << "item" }    # => true
    #   matcher.match? { array.clear }        # => true (from 1 to 0)
    #   matcher.match? { array.dup }          # => false (no change)
    #
    # @example With method parameters
    #   hash = { key: "old" }
    #   matcher = Change.new(hash, :fetch, :key)
    #   matcher.match? { hash[:key] = "new" }  # => true
    #   matcher.match? { hash[:key] = "new" }  # => false (same value)
    #
    # @example With computed values
    #   text = "hello"
    #   matcher = Change.new(text, :upcase)
    #   matcher.match? { text.upcase! }        # => true
    #   matcher.match? { text.upcase! }        # => false (already uppercase)
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      value_before = @state.call
      yield
      value_after = @state.call

      !value_before.eql?(value_after)
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   Change.new("test", :upcase).to_s # => 'eq "test"'
    def to_s
      "change #{@state.inspect}"
    end

    # Specifies a minimum delta of the expected change.
    #
    # @api public
    #
    # @param minimum_delta [#object_id] The minimum expected change amount
    #
    # @return [#match?] A matcher that verifies the minimum change
    #
    # @example
    #   counter = 0
    #   matcher = Change.new(counter, :to_i).by_at_least(5)
    #   matcher.match? { counter += 6 }  # => true
    def by_at_least(minimum_delta)
      ByAtLeast.new(minimum_delta, &@state)
    end

    # Specifies a maximum delta of the expected change.
    #
    # @api public
    #
    # @param maximum_delta [#object_id] The maximum allowed change amount
    #
    # @return [#match?] A matcher that verifies the maximum change
    #
    # @example
    #   counter = 0
    #   matcher = Change.new(counter, :to_i).by_at_most(5)
    #   matcher.match? { counter += 3 }  # => true
    def by_at_most(maximum_delta)
      ByAtMost.new(maximum_delta, &@state)
    end

    # Specifies the exact delta of the expected change.
    #
    # @api public
    #
    # @param delta [#object_id] The exact expected change amount
    #
    # @return [#match?] A matcher that verifies the exact change
    #
    # @example
    #   counter = 0
    #   matcher = Change.new(counter, :to_i).by(5)
    #   matcher.match? { counter += 5 }  # => true
    def by(delta)
      By.new(delta, &@state)
    end

    # Specifies the original value in a value transition check.
    #
    # @api public
    #
    # @param old_value [#object_id] The expected initial value
    #
    # @return [#to] A wrapper for creating a from/to matcher
    #
    # @example
    #   string = "foo"
    #   Change.new(string, :to_s).from("foo").to("FOO")
    def from(old_value)
      From.new(old_value, &@state)
    end

    # Specifies the final value to expect.
    #
    # @api public
    #
    # @param new_value [#object_id] The expected final value
    #
    # @return [#match?] A matcher that verifies the final state
    #
    # @example
    #   string = "foo"
    #   matcher = Change.new(string, :to_s).to("FOO")
    #   matcher.match? { string.upcase! }  # => true
    def to(new_value)
      To.new(new_value, &@state)
    end
  end
end
