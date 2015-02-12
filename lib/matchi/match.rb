module Matchi
  # **Regular expressions** matcher.
  class Match < BasicObject
    def initialize(expected)
      @expected = expected
    end

    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.match(yield).nil?.equal?(false)
    end
  end
end
