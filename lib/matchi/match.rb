# frozen_string_literal: true

module Matchi
  # Pattern matching matcher that checks if a value matches a regular expression.
  #
  # This matcher verifies that a value matches a pattern using Ruby's Regexp#match? method.
  # It's particularly useful for string validation, pattern matching, and text analysis.
  # The matcher ensures secure pattern matching by requiring the pattern to respond to match?.
  #
  # @example Basic usage
  #   matcher = Matchi::Match.new(/^test/)
  #   matcher.match? { "test_string" }     # => true
  #   matcher.match? { "other_string" }    # => false
  #
  # @example Case sensitivity
  #   matcher = Matchi::Match.new(/^test$/i)
  #   matcher.match? { "TEST" }            # => true
  #   matcher.match? { "Test" }            # => true
  #   matcher.match? { "testing" }         # => false
  #
  # @example Multiline patterns
  #   matcher = Matchi::Match.new(/\A\d+\Z/m)
  #   matcher.match? { "123" }             # => true
  #   matcher.match? { "12.3" }            # => false
  #
  # @see https://ruby-doc.org/core/Regexp.html#method-i-match-3F
  class Match
    # Initialize the matcher with a pattern.
    #
    # @api public
    #
    # @param expected [#match?] A pattern that responds to match?
    #
    # @raise [ArgumentError] if the pattern doesn't respond to match?
    #
    # @return [Match] a new instance of the matcher
    #
    # @example
    #   Match.new(/\d+/)           # Match digits
    #   Match.new(/^test$/i)       # Case-insensitive match
    #   Match.new(/\A\w+\Z/)       # Full string word characters
    def initialize(expected)
      raise ::ArgumentError, "expected must respond to match?" unless expected.respond_to?(:match?)

      @expected = expected
    end

    # Checks if the yielded value matches the expected pattern.
    #
    # This method uses the pattern's match? method to perform the comparison.
    # The match is performed on the entire string unless the pattern specifically
    # allows partial matches.
    #
    # @api public
    #
    # @yield [] Block that returns the value to check
    # @yieldreturn [#to_s] The value to match against the pattern
    #
    # @return [Boolean] true if the value matches the pattern
    #
    # @raise [ArgumentError] if no block is provided
    #
    # @example
    #   matcher = Match.new(/^\d{3}-\d{2}-\d{4}$/)
    #   matcher.match? { "123-45-6789" }   # => true
    #   matcher.match? { "123456789" }     # => false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.match?(yield)
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   Match.new(/^test/).to_s # => "match /^test/"
    def to_s
      "match #{@expected.inspect}"
    end
  end
end
