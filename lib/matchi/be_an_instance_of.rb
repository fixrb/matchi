# frozen_string_literal: true

module Matchi
  # *Type/class* matcher.
  class BeAnInstanceOf
    # Initialize the matcher with (the name of) a class or module.
    #
    # @example
    #   require "matchi/be_an_instance_of"
    #
    #   Matchi::BeAnInstanceOf.new(String)
    #
    # @param expected [Class, #to_s] The expected class name.
    def initialize(expected)
      @expected = String(expected)
    end

    # Boolean comparison between the class of the actual value and the
    # expected class.
    #
    # @example
    #   require "matchi/be_an_instance_of"
    #
    #   matcher = Matchi::BeAnInstanceOf.new(String)
    #   matcher.match? { "foo" } # => true
    #
    # @yieldreturn [#class] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def match?
      self.class.const_get(@expected).equal?(yield.class)
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{@expected})"
    end

    # Returns a string representing the matcher.
    def to_s
      "be an instance of #{@expected}"
    end
  end
end
