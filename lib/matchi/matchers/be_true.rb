# frozen_string_literal: true

require_relative File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Truth** matcher.
    module BeTrue
      # The matcher.
      class Matcher
        include MatchersBase

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it true?
        #   be_true = Matchi::Matchers::BeTrue::Matcher.new
        #   be_true.matches? { true } # => true
        #
        # @yieldreturn [#object_id] The actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?(*, **)
          true.equal?(yield)
        end
      end
    end
  end
end
