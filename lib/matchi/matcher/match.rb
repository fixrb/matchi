# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # **Regular expressions** matcher.
    class Match < ::Matchi::Matcher::Base
      # Initialize the matcher with an instance of Regexp.
      #
      # @example Username matcher.
      #   Matchi::Matcher::Match.new(/^[a-z0-9_-]{3,16}$/)
      #
      # @param expected [#match] A regular expression.
      def initialize(expected)
        super()
        @expected = expected
      end

      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it matching /^foo$/ regex?
      #   match = Matchi::Matcher::Match.new(/^foo$/)
      #   match.matches? { 'foo' } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        expected.match(yield).nil?.equal?(false)
      end
    end
  end
end
