# frozen_string_literal: true

module Matchi
  # *Equivalence* matcher.
  class Eq
    # Initialize the matcher with an object.
    #
    # @example
    #   require "matchi/eq"
    #
    #   Matchi::Eq.new("foo")
    #
    # @param expected [#eql?] An expected equivalent object.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/eq"
    #
    #   matcher = Matchi::Eq.new("foo")
    #   matcher.match? { "foo" } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.eql?(yield)
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{@expected.inspect})"
    end

    # Returns a string representing the matcher.
    def to_s
      "eq #{@expected.inspect}"
    end
  end
end
