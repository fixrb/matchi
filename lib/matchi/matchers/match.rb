require_relative File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Regular expressions** matcher.
    module Match
      # The matcher.
      class Matcher
        include MatchersBase

        # Initialize the matcher with an instance of Regexp.
        #
        # @example Username matcher.
        #   Matchi::Matchers::Match::Matcher.new(/^[a-z0-9_-]{3,16}$/)
        #
        # @param expected [#match] A regular expression.
        def initialize(expected)
          @expected = expected
        end

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it matching /^foo$/ regex?
        #   match = Matchi::Matchers::Match::Matcher.new(/^foo$/)
        #   match.matches? { 'foo' } # => true
        #
        # @yieldreturn [#object_id] the actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?
          @expected.match(yield).nil?.equal?(false)
        end
      end
    end
  end
end
