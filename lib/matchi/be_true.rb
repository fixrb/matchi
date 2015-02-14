module Matchi
  # **Truth** matcher.
  class BeTrue < BasicObject
    # @example Is it true?
    #   be_true = Matchi::BeTrue.new
    #   be_true.matches? { true } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      true.equal?(yield)
    end
  end
end
