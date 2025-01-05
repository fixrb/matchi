# frozen_string_literal: true

module Matchi
  # Custom predicate matcher that validates values against an arbitrary condition.
  #
  # This matcher provides a flexible way to test values against custom conditions
  # defined in a block. Unlike specific matchers that test for predetermined
  # conditions, Satisfy allows you to define any custom validation logic at runtime.
  # This makes it particularly useful for complex or composite conditions that
  # aren't covered by other matchers.
  #
  # @example Basic numeric validation
  #   matcher = Matchi::Satisfy.new { |n| n.positive? && n.even? }
  #   matcher.match? { 2 }             # => true
  #   matcher.match? { -2 }            # => false
  #   matcher.match? { 3 }             # => false
  #
  # @example String pattern validation
  #   matcher = Matchi::Satisfy.new { |s| s.start_with?("test") && s.length < 10 }
  #   matcher.match? { "test_123" }    # => true
  #   matcher.match? { "test_12345" }  # => false
  #   matcher.match? { "other" }       # => false
  #
  # @example Complex object validation
  #   class User
  #     attr_reader :age, :name
  #     def initialize(name, age)
  #       @name, @age = name, age
  #     end
  #   end
  #
  #   matcher = Matchi::Satisfy.new { |user|
  #     user.age >= 18 && user.name.length >= 2
  #   }
  #   matcher.match? { User.new("Alice", 25) }  # => true
  #   matcher.match? { User.new("B", 20) }      # => false
  #
  # @example Using with collections
  #   matcher = Matchi::Satisfy.new { |arr|
  #     arr.all? { |x| x.is_a?(Integer) } && arr.sum.even?
  #   }
  #   matcher.match? { [2, 4, 6] }      # => true
  #   matcher.match? { [1, 3, 5] }      # => false
  #   matcher.match? { [1, "2", 3] }    # => false
  #
  # @see https://ruby-doc.org/core/Proc.html
  # @see Matchi::Predicate  For testing existing predicate methods
  class Satisfy
    # Initialize the matcher with a validation block.
    #
    # @api public
    #
    # @yield [Object] Block that defines the validation condition
    # @yieldparam value The value to validate
    # @yieldreturn [Boolean] true if the value meets the condition
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @return [Satisfy] a new instance of the matcher
    #
    # @example Simple numeric validation
    #   Satisfy.new { |n| n > 0 }
    #
    # @example Complex condition
    #   Satisfy.new { |obj|
    #     obj.respond_to?(:length) && obj.length.between?(2, 10)
    #   }
    def initialize(&block)
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected = block
    end

    # Checks if the yielded value satisfies the validation block.
    #
    # This method passes the value returned by the provided block to the
    # validation block defined at initialization. The matcher succeeds if
    # the validation block returns a truthy value.
    #
    # @api public
    #
    # @yield [] Block that returns the value to validate
    # @yieldreturn [Object] The value to check against the condition
    #
    # @return [Boolean] true if the value satisfies the condition
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @example Using with direct values
    #   matcher = Satisfy.new { |n| n.positive? }
    #   matcher.match? { 42 }    # => true
    #   matcher.match? { -1 }    # => false
    #
    # @example Using with computed values
    #   matcher = Satisfy.new { |s| s.length.even? }
    #   matcher.match? { "test".upcase }  # => true
    #   matcher.match? { "a" * 3 }        # => false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.call(yield)
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   Satisfy.new { |n| n > 0 }.to_s  # => "satisfy &block"
    def to_s
      "satisfy &block"
    end
  end
end
