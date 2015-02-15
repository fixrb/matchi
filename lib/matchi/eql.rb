module Matchi
  # **Equivalence** matcher.
  class Eql < BasicObject
    # @param [#eql?] expected an expected equivalent object
    def initialize(expected)
      @expected = expected
    end

    # @example Is it equivalent to 'foo'?
    #   eql = Matchi::Eql.new('foo')
    #   eql.matches? { 'foo' } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.eql?(yield)
    end
  end
end
