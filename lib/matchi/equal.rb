module Matchi
  # **Identity** matcher.
  class Equal < BasicObject
    def initialize(expected)
      @expected = expected
    end

    # @example Is it equal to :foo?
    #   equal = Matchi::Equal.new(:foo)
    #   equal.matches? { :foo } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.equal?(yield)
    end
  end
end
