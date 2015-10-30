module Matchi
  # **Untruth** matcher.
  class BeFalse
    # Boolean comparison between the actual value and the expected value.
    #
    # @example Is it false?
    #   be_false = Matchi::BeFalse.new
    #   be_false.matches? { false } # => true
    #
    # @yieldreturn [#object_id] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      false.equal?(yield)
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      'be_false'
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
      { BeFalse: [] }
    end
  end
end
