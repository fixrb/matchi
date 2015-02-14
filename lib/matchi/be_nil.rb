module Matchi
  # **Nil** matcher.
  class BeNil < BasicObject
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      nil.equal?(yield)
    end
  end
end
