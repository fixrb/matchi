module Matchi
  # **Truth** matcher.
  class BeTrue < BasicObject
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      true.equal?(yield)
    end
  end
end
