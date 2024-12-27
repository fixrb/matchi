# frozen_string_literal: true

module Matchi
  # *Regular expressions* matcher.
  class Match
    # Initialize the matcher with an instance of Regexp.
    #
    # @example
    #   require "matchi/match"
    #
    #   Matchi::Match.new(/^foo$/)
    #
    # @param expected [#match] A regular expression.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/match"
    #
    #   matcher = Matchi::Match.new(/^foo$/)
    #   matcher.match? { "foo" } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      @expected.match?(yield)
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{@expected.inspect})"
    end

    # Returns a string representing the matcher.
    def to_s
      "match #{@expected.inspect}"
    end
  end
end
