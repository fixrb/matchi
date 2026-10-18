# frozen_string_literal: true

require_relative "change/delta"
require_relative "change/from"
require_relative "change/to"
require_relative "constant"

module Matchi
  # State change matcher: passes when evaluating the block changes the value
  # returned by a public method of an object.
  #
  # The observed method is called with `public_send` before and after the
  # block, and the two values are compared with `eql?`. The observed method
  # must return a value, not the mutated object itself: when it returns the
  # very same unfrozen object twice, the comparison cannot tell whether that
  # object changed, and `match?` raises instead of answering `false`.
  # `attr_reader :items` with `items << x` is that case; observe
  # `items.length` or use {#to}, which compares with the expected value. A
  # frozen object returned twice counts as an unchanged value.
  #
  # The refinements {#by}, {#by_at_least}, {#by_at_most}, {#from} and {#to}
  # build more specific matchers. `Change`, `by`, `by_at_least` and
  # `by_at_most` compare values produced by the observed object, so they
  # depend on its honesty, like {Matchi::Predicate}. `to` and `from … to`
  # compare with the expected value, like {Matchi::Eq}. Whatever the
  # observed method raises propagates.
  #
  # @example
  #   list = []
  #   Matchi::Change.new(list, :length).match? { list << 1 }       # => true
  #   Matchi::Change.new(list, :length).by(1).match? { list << 1 } # => true
  class Change
    # @param object [Object] the object to observe
    # @param method [Symbol, String] a public method of that object
    # @param args [Array] positional arguments for the method
    # @param kwargs [Hash] keyword arguments for the method
    # @param block [Proc, nil] a block for the method
    # @raise [ArgumentError] when method is neither a Symbol nor a String
    def initialize(object, method, *args, **kwargs, &block)
      raise ::ArgumentError, "method must be a Symbol or a String (got: #{method.inspect})" unless name?(method)

      @object = object
      @method = method.to_sym
      @state = -> { ::Kernel.instance_method(:public_send).bind_call(object, @method, *args, **kwargs, &block) }
    end

    # @yieldreturn [Object] ignored, the block is evaluated for its effect
    # @return [Boolean]
    # @raise [ArgumentError] when no block is given
    # @raise [NoMethodError] when the object has no such public method
    # @raise [TypeError] when the observed method returns the same unfrozen object twice
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      value_before = @state.call
      yield
      value_after = @state.call

      return !value_before.eql?(value_after) unless value_before.equal?(value_after)
      return false if ::Kernel.instance_method(:frozen?).bind_call(value_before)

      raise ::TypeError, "#{self} returned the same unfrozen object twice: observe a value, not the object"
    end

    # @return [String] the observed class and method, such as `change Array#length`
    def to_s
      "change #{Constant.label(::Kernel.instance_method(:class).bind_call(@object))}##{@method}"
    end

    # @param delta [Numeric] the exact expected difference, negative allowed
    # @return [Matchi::Change::Delta]
    # @raise [ArgumentError] when delta is not a finite real Numeric
    def by(delta)
      Delta.new(:by, delta, &@state)
    end

    # @param delta [Numeric] the smallest acceptable increase, zero or positive
    # @return [Matchi::Change::Delta]
    # @raise [ArgumentError] when delta is not a finite real non-negative Numeric
    def by_at_least(delta)
      Delta.new(:by_at_least, delta, &@state)
    end

    # @param delta [Numeric] the largest acceptable increase, zero or positive
    # @return [Matchi::Change::Delta]
    # @raise [ArgumentError] when delta is not a finite real non-negative Numeric
    def by_at_most(delta)
      Delta.new(:by_at_most, delta, &@state)
    end

    # @param old_value [#eql?] the expected value before the block
    # @return [Matchi::Change::From] a builder; call `to` on it
    def from(old_value)
      From.new(old_value, &@state)
    end

    # @param new_value [#eql?] the expected value after the block
    # @return [Matchi::Change::To]
    def to(new_value)
      To.new(new_value, &@state)
    end

    private

    def name?(method)
      ::Symbol === method || ::String === method
    end
  end
end
