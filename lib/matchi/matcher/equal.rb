# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Identity* matcher.
    class Equal < ::Matchi::Matcher::Base
      # Initialize the matcher with an object.
      #
      # @example The number 42 matcher.
      #   Matchi::Matcher::Equal.new(42)
      #
      # @param expected [#equal?] An expected object.
      def initialize(expected)
        super()
        @expected = expected
      end

      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it equal to :foo?
      #   equal = Matchi::Matcher::Equal.new(:foo)
      #   equal.matches? { :foo } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        expected.equal?(yield)
      end
    end
  end
end
