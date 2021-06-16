# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Truth* matcher.
    class BeTrue < ::Matchi::Matcher::Base
      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it true?
      #   be_true = Matchi::Matcher::BeTrue.new
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
