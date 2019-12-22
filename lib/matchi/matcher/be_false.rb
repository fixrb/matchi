# frozen_string_literal: true

require_relative 'base'

module Matchi
  module Matcher
    # **Untruth** matcher.
    class BeFalse < ::Matchi::Matcher::Base
      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it false?
      #   be_false = Matchi::Matcher::BeFalse.new
      #   be_false.matches? { false } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        false.equal?(yield)
      end
    end
  end
end
