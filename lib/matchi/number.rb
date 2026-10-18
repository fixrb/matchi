# frozen_string_literal: true

module Matchi
  # Validation of the numbers given to matchers: deltas and expected values
  # must be finite and real, so that a `NaN`, an infinity or a `Complex`
  # cannot build a matcher that never, or always, passes.
  #
  # @api private
  module Number
    # @param value [Object]
    # @return [Boolean] whether value is a finite real Numeric
    def self.finite_real?(value)
      ::Numeric === value && value.real? && value.finite?
    end

    # @param value [Object]
    # @param role [String] the argument name, for the error message
    # @return [Numeric] value
    # @raise [ArgumentError] when value is not a finite real Numeric
    def self.finite_real!(value, role)
      raise ::ArgumentError, "#{role} must be a finite real Numeric (got: #{value.inspect})" unless finite_real?(value)

      value
    end

    # @param value [Object]
    # @param role [String] the argument name, for the error message
    # @return [Numeric] value
    # @raise [ArgumentError] when value is not a finite real non-negative Numeric
    def self.non_negative!(value, role)
      finite_real!(value, role)
      raise ::ArgumentError, "#{role} must be non-negative (got: #{value.inspect})" if value.negative?

      value
    end
  end
end
