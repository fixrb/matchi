# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Equivalence* matcher.
    class Eql < ::Matchi::Matcher::Base
      # Initialize the matcher with an object.
      #
      # @example The string 'foo' matcher.
      #   Matchi::Matcher::Eql.new('foo')
      #
      # @param expected [#eql?] An expected equivalent object.
      def initialize(expected)
        super()
        @expected = expected
      end

      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it equivalent to 'foo'?
      #   eql = Matchi::Matcher::Eql.new('foo')
      #   eql.matches? { 'foo' } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        expected.eql?(yield)
      end
    end
  end
end
