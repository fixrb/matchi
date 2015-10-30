module Matchi
  # **Expecting errors** matcher.
  class RaiseException < BasicObject
    # Initialize the matcher with a descendant of class Exception.
    #
    # @example Divided by 0 matcher.
    #   Matchi::RaiseException.new(ZeroDivisionError)
    #
    # @param expected [.exception] The class of the expected exception.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example Is it raising NameError?
    #   raise_exception = Matchi::RaiseException.new(NameError)
    #   raise_exception.matches? { Boom } # => true
    #
    # @yieldreturn [#object_id] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      yield
    rescue @expected
      true
    else
      false
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      "raise_exception #{@expected.inspect}"
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
      { RaiseException: [@expected] }
    end
  end
end
