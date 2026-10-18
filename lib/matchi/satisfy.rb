# frozen_string_literal: true

require_relative "constant"

module Matchi
  # Custom matcher: passes when the given block, called with the actual value,
  # returns `true`. The block must return `true` or `false`; any other value
  # is an error, not a truthy pass.
  #
  # @example
  #   Matchi::Satisfy.new { |value| value > 41 }.match? { 42 } # => true
  class Satisfy
    # @yieldparam actual [Object] the actual value
    # @yieldreturn [Boolean]
    # @raise [ArgumentError] when no block is given
    def initialize(&block)
      raise ::ArgumentError, "a block must be provided" unless block_given?

      @predicate = block
    end

    # @yieldreturn [Object] the actual value
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [TypeError] when the predicate returns something other than true or false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      result = @predicate.call(yield)
      return result if true.equal?(result) || false.equal?(result)

      klass = ::Kernel.instance_method(:class).bind_call(result)
      raise ::TypeError, "the block must return true or false (got a #{Constant.label(klass)})"
    end

    # @return [String]
    def to_s
      "satisfy &block"
    end
  end
end
