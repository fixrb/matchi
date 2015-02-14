module Matchi
  # **Untruth** matcher.
  class BeFalse < BasicObject
    # @example Is it false?
    #   be_false = Matchi::BeFalse.new
    #   be_false.matches? { false } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      false.equal?(yield)
    end
  end
end
