# frozen_string_literal: true

require_relative "../number"

module Matchi
  class BeWithin
    # Numeric proximity matcher: passes when the actual value is a core number
    # whose distance to the expected value is at most delta.
    #
    # The actual value must be an `Integer`, a `Float`, a `Rational` or a
    # `BigDecimal` (its class is read with `Kernel#class` bound to it). Any
    # other value fails, including a user-defined `Numeric` subclass: such an
    # object would control the subtraction through `coerce`.
    #
    # @example
    #   Matchi::BeWithin::Of.new(1, 42).match? { 41 }   # => true
    #   Matchi::BeWithin::Of.new(1, 42).match? { "42" } # => false
    class Of
      # @param delta [Numeric] the tolerance: a finite, real, non-negative number
      # @param expected [Numeric] the center of the interval: a finite, real number
      # @raise [ArgumentError] when an argument is not such a number
      def initialize(delta, expected)
        @delta = Number.non_negative!(delta, "delta")
        @expected = Number.finite_real!(expected, "expected")
      end

      # @yieldreturn [Object] the actual value
      # @return [Boolean]
      # @raise [ArgumentError] when no block is given
      def match?
        raise ::ArgumentError, "a block must be provided" unless block_given?

        actual = yield
        return false unless core_number?(actual)

        (@expected - actual).abs <= @delta
      end

      # @return [String]
      def to_s
        "be within #{@delta.inspect} of #{@expected.inspect}"
      end

      private

      CORE = [::Integer, ::Float, ::Rational].freeze
      private_constant :CORE

      def core_number?(actual)
        klass = ::Kernel.instance_method(:class).bind_call(actual)
        return true if CORE.include?(klass)

        defined?(::BigDecimal) ? klass.equal?(::BigDecimal) : false
      end
    end
  end
end
