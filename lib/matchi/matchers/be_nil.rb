# frozen_string_literal: true

require_relative File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Nil** matcher.
    module BeNil
      # The matcher.
      class Matcher
        include MatchersBase

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it nil?
        #   be_nil = Matchi::Matchers::BeNil::Matcher.new
        #   be_nil.matches? { nil } # => true
        #
        # @yieldreturn [#object_id] The actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?(*, **)
          nil.equal?(yield)
        end
      end
    end
  end
end
