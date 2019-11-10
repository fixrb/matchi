# frozen_string_literal: true

require_relative ::File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Untruth** matcher.
    module BeFalse
      # The matcher.
      class Matcher
        include MatchersBase

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it false?
        #   be_false = Matchi::Matchers::BeFalse::Matcher.new
        #   be_false.matches? { false } # => true
        #
        # @yieldreturn [#object_id] the actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?
          false.equal?(yield)
        end
      end
    end
  end
end
