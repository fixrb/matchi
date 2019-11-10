# frozen_string_literal: true

require_relative ::File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Equivalence** matcher.
    module Eql
      # The matcher.
      class Matcher
        include MatchersBase

        # Initialize the matcher with an object.
        #
        # @example The string 'foo' matcher.
        #   Matchi::Matchers::Eql::Matcher.new('foo')
        #
        # @param expected [#eql?] An expected equivalent object.
        def initialize(expected)
          @expected = expected
        end

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it equivalent to 'foo'?
        #   eql = Matchi::Matchers::Eql::Matcher.new('foo')
        #   eql.matches? { 'foo' } # => true
        #
        # @yieldreturn [#object_id] the actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?
          @expected.eql?(yield)
        end
      end
    end
  end
end
