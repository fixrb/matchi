# frozen_string_literal: true

module Matchi
  # Value equivalence matcher that checks if two objects have identical values.
  #
  # This matcher verifies value equality using Ruby's Object#eql? method, which
  # compares the values of objects rather than their identity. This is different
  # from identity comparison (equal?) which checks if objects are the same instance.
  #
  # @example Basic usage with strings
  #   matcher = Matchi::Eq.new("test")
  #   matcher.match? { "test" }         # => true
  #   matcher.match? { "test".dup }     # => true
  #   matcher.match? { "other" }        # => false
  #
  # @example With numbers
  #   matcher = Matchi::Eq.new(42)
  #   matcher.match? { 42 }             # => true
  #   matcher.match? { 42.0 }           # => false  # Different types
  #   matcher.match? { 43 }             # => false
  #
  # @example With collections
  #   array = [1, 2, 3]
  #   matcher = Matchi::Eq.new(array)
  #   matcher.match? { array.dup }      # => true   # Same values
  #   matcher.match? { array }          # => true   # Same object
  #   matcher.match? { [1, 2, 3] }      # => true   # Same values
  #   matcher.match? { [1, 2] }         # => false  # Different values
  #
  # @see https://ruby-doc.org/core/Object.html#method-i-eql-3F
  # @see Matchi::Be
  class Eq
    # Initialize the matcher with a reference value.
    #
    # @api public
    #
    # @param expected [#eql?] The expected equivalent value
    #
    # @return [Eq] a new instance of the matcher
    #
    # @example
    #   Eq.new("test")              # Match strings with same value
    #   Eq.new([1, 2, 3])           # Match arrays with same elements
    def initialize(expected)
      @expected = expected
    end

    # Checks if the yielded object has a value equivalent to the expected object.
    #
    # This method uses Ruby's Object#eql? method, which performs value comparison.
    # Two objects are considered equivalent if they have the same value, even if
    # they are different instances.
    #
    # @api public
    #
    # @yield [] Block that returns the object to check
    # @yieldreturn [Object] The object to verify equivalence with
    #
    # @return [Boolean] true if both objects have equivalent values
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @example
    #   matcher = Eq.new([1, 2, 3])
    #   matcher.match? { [1, 2, 3] }      # => true
    #   matcher.match? { [1, 2, 3].dup }  # => true
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.eql?(yield)
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   Eq.new("test").to_s # => 'eq "test"'
    def to_s
      "eq #{@expected.inspect}"
    end
  end
end
