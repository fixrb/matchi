# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Nil* matcher.
    class BeNil < ::Matchi::Matcher::Base
      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it nil?
      #   be_nil = Matchi::Matcher::BeNil.new
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
