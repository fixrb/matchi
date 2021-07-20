# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Satisfy* matcher.
    class Satisfy < ::Matchi::Matcher::Base
      # Initialize the matcher with a block.
      #
      # @example The number 42 matcher.
      #   Matchi::Matcher::Satisfy.new { |value| value == 42 }
      #
      # @param block [Proc] A block of code.
      def initialize(&block)
        super()
        @expected = block
      end

      # (see Base#inspect)
      def inspect
        "#{self.class}(&block)"
      end

      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it equal to 42
      #   equal = Matchi::Matcher::Satisfy.new { |value| value == 42 }
      #   equal.matches? { 42 } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        expected.call(yield)
      end

      # (see Base#to_s)
      def to_s
        "#{self.class.to_sym} &block"
      end
    end
  end
end
