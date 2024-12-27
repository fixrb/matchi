# frozen_string_literal: true

require_relative File.join("be_within", "of")

module Matchi
  # Wraps the target of a be_within matcher.
  class BeWithin
    # Initialize a wrapper of the be_within matcher with a numeric value.
    #
    # @example
    #   require "matchi/be_within"
    #
    #   Matchi::BeWithin.new(1)
    #
    # @param delta [Numeric] A numeric value.
    def initialize(delta)
      @delta = delta
    end

    # Specifies an expected numeric value.
    #
    # @example
    #   require "matchi/be_within"
    #
    #   be_within_wrapper = Matchi::BeWithin.new(1)
    #   be_within_wrapper.of(41)
    #
    # @param expected [Numeric] The expected value.
    #
    # @return [#match?] A *be_within of* matcher.
    def of(expected)
      Of.new(@delta, expected)
    end
  end
end
