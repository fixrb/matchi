# frozen_string_literal: true

require_relative "constant"

module Matchi
  # Type matcher: passes when the actual value is an instance of the expected
  # module or of one of its descendants (`Module#===`, so a `BasicObject` is
  # handled and an object redefining `is_a?` cannot lie).
  #
  # The expected module can be given directly, or by name; see
  # {Matchi::Constant}.
  #
  # @example
  #   Matchi::BeAKindOf.new(Numeric).match? { 42 }    # => true
  #   Matchi::BeAKindOf.new(:Numeric).match? { "42" } # => false
  class BeAKindOf
    # @param expected [Module, String, Symbol] the expected module, or its name
    # @raise [ArgumentError] when expected is neither a Module nor a constant name
    def initialize(expected)
      @expected = Constant.normalize(expected, ::Module)
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [NameError] when the name is not defined
    # @raise [TypeError] when the name does not resolve to a Module
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      Constant.resolve(@expected, ::Module) === yield
    end

    # @return [String]
    def to_s
      "be a kind of #{Constant.label(@expected)}"
    end
  end
end
