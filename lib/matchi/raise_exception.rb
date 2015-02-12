module Matchi
  # **Expecting errors** matcher.
  class RaiseException < BasicObject
    def initialize(expected)
      @expected = expected
    end

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
