# frozen_string_literal: true

module Matchi
  # Identity matcher: passes when the actual value is the very same object as
  # the expected one (`equal?`).
  #
  # @example
  #   Matchi::Be.new(:foo).match? { :foo } # => true
  #   Matchi::Be.new("a").match? { "a".dup } # => false (another object)
  class Be
    # @param expected [Object] the expected object
    def initialize(expected)
      @expected = expected
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @expected.equal?(yield)
    end

    # @return [String]
    def to_s
      "be #{@expected.inspect}"
    end
  end
end
