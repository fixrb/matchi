module Matchi
  # **Untruth** matcher.
  class BeFalse < BasicObject
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      false.equal?(yield)
    end
  end
end
