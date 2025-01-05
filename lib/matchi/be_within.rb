# frozen_string_literal: true

module Matchi
  # Delta comparison matcher that checks if a numeric value is within a specified range.
  #
  # This matcher verifies that a numeric value falls within a certain distance (delta)
  # of an expected value. It's particularly useful for floating-point comparisons or
  # when checking if a value is approximately equal to another within a given tolerance.
  #
  # @example Basic usage with integers
  #   matcher = Matchi::BeWithin.new(1).of(10)
  #   matcher.match? { 9 }    # => true
  #   matcher.match? { 10 }   # => true
  #   matcher.match? { 11 }   # => true
  #   matcher.match? { 12 }   # => false
  #
  # @example Floating point comparisons
  #   matcher = Matchi::BeWithin.new(0.1).of(3.14)
  #   matcher.match? { 3.1 }   # => true
  #   matcher.match? { 3.2 }   # => true
  #   matcher.match? { 3.0 }   # => false
  #
  # @example Working with percentages
  #   matcher = Matchi::BeWithin.new(5).of(100)  # 5% margin
  #   matcher.match? { 95 }    # => true
  #   matcher.match? { 105 }   # => true
  #   matcher.match? { 110 }   # => false
  #
  # @see https://ruby-doc.org/core/Numeric.html#method-i-abs
  class BeWithin
    # Initialize the matcher with a delta value.
    #
    # @api public
    #
    # @param delta [Numeric] The maximum allowed difference from the expected value
    #
    # @raise [ArgumentError] if delta is not a Numeric
    # @raise [ArgumentError] if delta is negative
    #
    # @return [BeWithin] a new instance of the matcher
    #
    # @example
    #   BeWithin.new(0.5)           # Using float
    #   BeWithin.new(2)             # Using integer
    def initialize(delta)
      raise ::ArgumentError, "delta must be a Numeric" unless delta.is_a?(::Numeric)
      raise ::ArgumentError, "delta must be non-negative" if delta.negative?

      @delta = delta
    end

    # Raises NotImplementedError as this is not a complete matcher.
    #
    # This class acts as a builder for the actual matcher, which is created
    # by calling the #of method. Direct use of #match? is not supported.
    #
    # @api public
    #
    # @raise [NotImplementedError] always, as this method should not be used
    #
    # @example
    #   # Don't do this:
    #   BeWithin.new(0.5).match? { 42 }  # Raises NotImplementedError
    #
    #   # Do this instead:
    #   BeWithin.new(0.5).of(42).match? { 41.8 }  # Works correctly
    def match?
      raise ::NotImplementedError, "BeWithin is not a complete matcher. Use BeWithin#of to create a valid matcher."
    end

    # Specifies the expected reference value.
    #
    # @api public
    #
    # @param expected [Numeric] The reference value to compare against
    #
    # @raise [ArgumentError] if expected is not a Numeric
    #
    # @return [#match?] A matcher that checks if a value is within the specified range
    #
    # @example
    #   be_within_wrapper = BeWithin.new(0.5)
    #   be_within_wrapper.of(3.14)  # Creates matcher for values in range 2.64..3.64
    def of(expected)
      Of.new(@delta, expected)
    end

    # Nested class that performs the actual comparison.
    #
    # This class implements the actual matching logic, comparing the provided value
    # against the expected value using the specified delta.
    class Of
      # Initialize the matcher with a delta and an expected value.
      #
      # @api private
      #
      # @param delta [Numeric] The maximum allowed difference from the expected value
      # @param expected [Numeric] The reference value to compare against
      #
      # @raise [ArgumentError] if delta is not a Numeric
      # @raise [ArgumentError] if expected is not a Numeric
      # @raise [ArgumentError] if delta is negative
      def initialize(delta, expected)
        raise ::ArgumentError, "delta must be a Numeric" unless delta.is_a?(::Numeric)
        raise ::ArgumentError, "expected must be a Numeric" unless expected.is_a?(::Numeric)
        raise ::ArgumentError, "delta must be non-negative" if delta.negative?

        @delta = delta
        @expected = expected
      end

      # Checks if the yielded value is within the accepted range.
      #
      # The value is considered within range if its absolute difference from the
      # expected value is less than or equal to the specified delta.
      #
      # @api public
      #
      # @yield [] Block that returns the value to check
      # @yieldreturn [Numeric] The value to verify
      #
      # @return [Boolean] true if the value is within the accepted range
      #
      # @raise [ArgumentError] if no block is provided
      #
      # @example
      #   matcher = BeWithin.new(0.5).of(3.14)
      #   matcher.match? { 3.0 }   # => true
      #   matcher.match? { 4.0 }   # => false
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        (@expected - yield).abs <= @delta
      end

      # Returns a human-readable description of the matcher.
      #
      # @api public
      #
      # @return [String] A string describing what this matcher verifies
      #
      # @example
      #   BeWithin.new(0.5).of(3.14).to_s # => "be within 0.5 of 3.14"
      def to_s
        "be within #{@delta} of #{@expected}"
      end
    end
  end
end
