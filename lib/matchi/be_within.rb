# frozen_string_literal: true

require_relative "be_within/of"
require_relative "number"

module Matchi
  # Builder for the `be within DELTA of EXPECTED` matcher. It is not a matcher
  # itself: it does not respond to `match?`, so a framework that checks the
  # matcher interface rejects a forgotten `of`.
  #
  # @example
  #   Matchi::BeWithin.new(0.5).of(3).match? { 3.2 } # => true
  class BeWithin
    # @param delta [Numeric] the tolerance: a finite, real, non-negative number
    # @raise [ArgumentError] when delta is not such a number
    def initialize(delta)
      @delta = Number.non_negative!(delta, "delta")
    end

    # @param expected [Numeric] the center of the interval, a finite real number
    # @return [Matchi::BeWithin::Of] the matcher
    # @raise [ArgumentError] when expected is not a finite real Numeric
    def of(expected)
      Of.new(@delta, expected)
    end

    # @return [String]
    def to_s
      "be within #{@delta.inspect}"
    end
  end
end
