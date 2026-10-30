# frozen_string_literal: true

module Matchi
  # Regular expression matcher: passes when the actual value is a String or a
  # Symbol that the expected Regexp matches. Any other actual value fails, as
  # does a string with an invalid or incompatible encoding.
  #
  # Only a `Regexp` is accepted as pattern: with a `String` pattern,
  # `String#match?` would turn the actual value into the regular expression,
  # handing the comparison to the code under test. Use {Matchi::Satisfy} for
  # other predicates.
  #
  # @example
  #   Matchi::Match.new(/^foo/).match? { "foobar" } # => true
  #   Matchi::Match.new(/^foo/).match? { 42 }       # => false
  class Match
    # @param expected [Regexp] the pattern
    # @raise [ArgumentError] when expected is not a Regexp
    def initialize(expected)
      raise ::ArgumentError, "expected must be a Regexp (got: #{expected.inspect})" unless ::Regexp === expected

      @expected = expected
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      actual = yield
      return false unless ::String === actual || ::Symbol === actual

      # A plain copy: a subclass of String has no say in the comparison.
      string = ::String.new(::Symbol === actual ? actual.name : actual)
      return false unless string.valid_encoding?

      begin
        @expected.match?(string)
      rescue ::Encoding::CompatibilityError
        false
      end
    end

    # @return [String]
    def to_s
      "match #{@expected.inspect}"
    end
  end
end
