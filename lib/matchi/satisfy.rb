# frozen_string_literal: true

module Matchi
  # *Satisfy* matcher.
  class Satisfy
    # @return [Proc] A block of code.
    attr_reader :expected

    # Initialize the matcher with a block.
    #
    # @example
    #   require "matchi/satisfy"
    #
    #   Matchi::Satisfy.new { |value| value == 42 }
    #
    # @param block [Proc] A block of code.
    def initialize(&block)
      @expected = block
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/satisfy"
    #
    #   matcher = Matchi::Satisfy.new { |value| value == 42 }
    #
    #   matcher.expected        # => #<Proc:0x00007fbaafc65540>
    #   matcher.matches? { 42 } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      expected.call(yield)
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(&block)"
    end

    # Returns a string representing the matcher.
    def to_s
      "satisfy &block"
    end
  end
end
