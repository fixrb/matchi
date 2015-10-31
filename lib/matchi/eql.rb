module Matchi
  # **Equivalence** matcher.
  class Eql
    # Initialize the matcher with an object.
    #
    # @example The string 'foo' matcher.
    #   Matchi::Eql.new('foo')
    #
    # @param expected [#eql?] An expected equivalent object.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example Is it equivalent to 'foo'?
    #   eql = Matchi::Eql.new('foo')
    #   eql.matches? { 'foo' } # => true
    #
    # @yieldreturn [#object_id] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.eql?(yield)
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      "eql #{@expected.inspect}"
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
      { Eql: [@expected] }
    end
  end
end
