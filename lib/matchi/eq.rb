# frozen_string_literal: true

module Matchi
  # Equivalence matcher: passes when the actual value is of the same class as
  # the expected value and `eql?` to it.
  #
  # The expected value receives the `eql?` call, so the actual value cannot
  # lie. The class check comes first because a few core `eql?` methods, such
  # as `Hash#eql?`, hand the comparison back to an operand of another class;
  # it costs nothing, since `eql?` never holds across classes for core values.
  #
  # @example
  #   Matchi::Eq.new("foo").match? { "foo" } # => true
  #   Matchi::Eq.new(1).match? { 1.0 }       # => false (eql? is strict on type)
  class Eq
    # @param expected [#eql?] the expected value
    def initialize(expected)
      @expected = expected
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      Eq.eql?(@expected, yield)
    end

    # @return [String]
    def to_s
      "eq #{@expected.inspect}"
    end

    # @param expected [#eql?] the value that receives the comparison
    # @param actual [Object] a value from the code under test
    # @return [Boolean] whether actual is of the class of expected and `eql?` to it
    def self.eql?(expected, actual)
      return false unless ::Kernel.instance_method(:class).bind_call(actual).equal?(expected.class)

      expected.eql?(actual) ? true : false
    end
  end
end
