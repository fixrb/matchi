# frozen_string_literal: true

module Matchi
  # *Identity* matcher.
  class Be
    # @return [#equal?] The expected identical object.
    attr_reader :expected

    # Initialize the matcher with an object.
    #
    # @example
    #   require "matchi/be"
    #
    #   Matchi::Be.new(:foo)
    #
    # @param expected [#equal?] The expected identical object.
    def initialize(expected)
      @expected = expected
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/be"
    #
    #   matcher = Matchi::Be.new(:foo)
    #
    #   matcher.expected          # => :foo
    #   matcher.matches? { :foo } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      expected.equal?(yield)
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{expected.inspect})"
    end

    # Returns a string representing the matcher.
    def to_s
      "be #{expected.inspect}"
    end
  end
end
