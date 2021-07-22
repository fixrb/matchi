# frozen_string_literal: true

module Matchi
  # *Expecting errors* matcher.
  class RaiseException
    # @return [Symbol] The expected exception name.
    attr_reader :expected

    # Initialize the matcher with a descendant of class Exception.
    #
    # @example
    #   require "matchi/raise_exception"
    #
    #   Matchi::RaiseException.new(NameError)
    #
    # @param expected [Exception, #to_s] The expected exception name.
    def initialize(expected)
      @expected = String(expected).to_sym
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/raise_exception"
    #
    #   matcher = Matchi::RaiseException.new(NameError)
    #
    #   matcher.expected          # => :NameError
    #   matcher.matches? { Boom } # => true
    #
    # @yieldreturn [#object_id] The actual value to compare to the expected
    #   one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      yield
    rescue self.class.const_get(expected) => _e
      true
    else
      false
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{expected})"
    end

    # Returns a string representing the matcher.
    def to_s
      "raise exception #{expected}"
    end
  end
end
