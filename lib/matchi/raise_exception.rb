module Matchi
  # **Expecting errors** matcher.
  class RaiseException < BasicObject
    # @param [.exception] expected the class of the expected exception
    def initialize(expected)
      @expected = expected
    end

    # @example Is it raising NameError?
    #   raise_exception = Matchi::RaiseException.new(NameError)
    #   raise_exception.matches? { Boom } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      yield
    rescue @expected
      true
    else
      false
    end
  end
end
