# frozen_string_literal: true

module Matchi
  # Identity matcher that checks if two objects are the exact same instance.
  #
  # This matcher verifies object identity using Ruby's Object#equal? method, which
  # compares object IDs to determine if two references point to the exact same object
  # in memory. This is different from equality comparison (==) which compares values.
  #
  # @example Basic usage with symbols
  #   matcher = Matchi::Be.new(:foo)
  #   matcher.match? { :foo }             # => true
  #   matcher.match? { :bar }             # => false
  #
  # @example Identity comparison with strings
  #   string = "test"
  #   matcher = Matchi::Be.new(string)
  #   matcher.match? { string }           # => true
  #   matcher.match? { string.dup }       # => false
  #   matcher.match? { "test" }           # => false
  #
  # @example With mutable objects
  #   array = [1, 2, 3]
  #   matcher = Matchi::Be.new(array)
  #   matcher.match? { array }            # => true
  #   matcher.match? { array.dup }        # => false
  #   matcher.match? { [1, 2, 3] }        # => false
  #
  # @see https://ruby-doc.org/core/Object.html#method-i-equal-3F
  # @see Matchi::Eq
  class Be
    # Initialize the matcher with a reference object.
    #
    # @api public
    #
    # @param expected [#equal?] The expected identical object
    #
    # @return [Be] a new instance of the matcher
    #
    # @example
    #   string = "test"
    #   Be.new(string)             # Match only the same string instance
    def initialize(expected)
      @expected = expected
    end

    # Checks if the yielded object is the same instance as the expected object.
    #
    # This method uses Ruby's Object#equal? method, which performs identity comparison
    # by comparing object IDs. Two objects are considered identical only if they are
    # the exact same instance in memory.
    #
    # @api public
    #
    # @yield [] Block that returns the object to check
    # @yieldreturn [Object] The object to verify identity with
    #
    # @return [Boolean] true if both objects are the same instance
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @example
    #   obj = "test"
    #   matcher = Be.new(obj)
    #   matcher.match? { obj }      # => true
    #   matcher.match? { obj.dup }  # => false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.equal?(yield)
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   Be.new("test").to_s # => 'be "test"'
    def to_s
      "be #{@expected.inspect}"
    end
  end
end
