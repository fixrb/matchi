module Matchi
  # **Regular expressions** matcher.
  class Match < BasicObject
    # Initialize the matcher with an instance of Regexp.
    #
    # @example Username matcher
    #   Matchi::Match.new(/^[a-z0-9_-]{3,16}$/)
    #
    # @param [#match] expected a regular expression
    def initialize(expected)
      @expected = expected
    end

    # @example Is it matching /^foo$/ regex?
    #   match = Matchi::Match.new(/^foo$/)
    #   match.matches? { 'foo' } # => true
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      @expected.match(yield).nil?.equal?(false)
    end
  end
end
