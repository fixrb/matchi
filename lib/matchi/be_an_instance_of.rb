# frozen_string_literal: true

require_relative "constant"

module Matchi
  # Exact type matcher: passes when the class of the actual value is the
  # expected class itself, not a descendant.
  #
  # The class of the actual value is read with `Kernel#class` bound to it, so
  # an object that redefines `class` cannot lie, and a `BasicObject` is
  # handled. The expected class can be given directly, or by name; see
  # {Matchi::Constant}.
  #
  # @example
  #   Matchi::BeAnInstanceOf.new(Integer).match? { 42 }   # => true
  #   Matchi::BeAnInstanceOf.new(:Numeric).match? { 42 }  # => false
  class BeAnInstanceOf
    # @param expected [Class, String, Symbol] the expected class, or its name
    # @raise [ArgumentError] when expected is neither a Class nor a constant name
    def initialize(expected)
      @expected = Constant.normalize(expected, ::Class)
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [NameError] when the name is not defined
    # @raise [TypeError] when the name does not resolve to a Class
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      actual_class = ::Kernel.instance_method(:class).bind_call(yield)

      Constant.resolve(@expected, ::Class).equal?(actual_class)
    end

    # @return [String]
    def to_s
      "be an instance of #{Constant.label(@expected)}"
    end
  end
end
