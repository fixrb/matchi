module Matchi
  # **Identity** matcher.
  class Equal < BasicObject
    # Initialize the matcher with an object.
    #
    # @example The number 42 matcher.
    #   Matchi::Equal.new(42)
    #
    # @param expected [#equal?] An expected object.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example Is it equal to :foo?
    #   equal = Matchi::Equal.new(:foo)
    #   equal.matches? { :foo } # => true
    #
    # @yieldreturn [#object_id] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.equal?(yield)
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      "equal #{@expected.inspect}"
    end

    # Returns a hash of one key-value pair with a key corresponding to the
    #   matcher and a value corresponding to its initialize parameters.
    #
    # @example A FooBar matcher serialized into a hash.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_h # => { FooBar: 42 }
    #
    # @return [Hash] A hash of one key-value pair.
    def to_h
      { Equal: [@expected] }
    end
  end
end
