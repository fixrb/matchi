# frozen_string_literal: true

require_relative File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Identity** matcher.
    module Equal
      # The matcher.
      class Matcher
        include MatchersBase

        # Initialize the matcher with an object.
        #
        # @example The number 42 matcher.
        #   Matchi::Matchers::Equal::Matcher.new(42)
        #
        # @param expected [#equal?] An expected object.
        def initialize(expected)
          @expected = expected
        end

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it equal to :foo?
        #   equal = Matchi::Matchers::Equal::Matcher.new(:foo)
        #   equal.matches? { :foo } # => true
        #
        # @yieldreturn [#object_id] The actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?(**)
          @expected.equal?(yield)
        end
      end
    end
  end
end
