# frozen_string_literal: true

module Matchi
  # *Type/class* matcher for inheritance-aware type checking.
  #
  # This matcher provides a clear way to check if an object is an instance of a
  # specific class or one of its subclasses. It leverages Ruby's native === operator
  # which reliably handles class hierarchy relationships.
  #
  # @example Basic usage
  #   require "matchi/be_a_kind_of"
  #
  #   matcher = Matchi::BeAKindOf.new(Numeric)
  #   matcher.match? { 42 }     # => true
  #   matcher.match? { 42.0 }   # => true
  #   matcher.match? { "42" }   # => false
  class BeAKindOf
    # Initialize the matcher with (the name of) a class or module.
    #
    # @example
    #   require "matchi/be_a_kind_of"
    #
    #   Matchi::BeAKindOf.new(String)
    #   Matchi::BeAKindOf.new("String")
    #   Matchi::BeAKindOf.new(:String)
    #
    # @param expected [Class, #to_s] The expected class name
    # @raise [ArgumentError] if the class name doesn't start with an uppercase letter
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ::ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Checks if the yielded object is an instance of the expected class
    # or one of its subclasses.
    #
    # This method uses the case equality operator (===) which provides a reliable
    # way to check class hierarchy relationships in Ruby. When a class is the
    # receiver of ===, it returns true if the argument is an instance of that
    # class or one of its subclasses.
    #
    # @example Class hierarchy check
    #   class Animal; end
    #   class Dog < Animal; end
    #
    #   matcher = Matchi::BeAKindOf.new(Animal)
    #   matcher.match? { Dog.new }    # => true
    #   matcher.match? { Animal.new } # => true
    #   matcher.match? { Object.new } # => false
    #
    # @yieldreturn [Object] the actual value to check
    # @return [Boolean] true if the object is an instance of the expected class or one of its subclasses
    # @raise [ArgumentError] if no block is provided
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      expected_class === yield # rubocop:disable Style/CaseEquality
    end

    # Returns a string representing the matcher.
    #
    # @return [String] a human-readable description of the matcher
    def to_s
      "be a kind of #{@expected}"
    end

    private

    # Resolves the expected class name to an actual Class object.
    # This method handles both string and symbol class names through constant resolution.
    #
    # @return [Class] the resolved class
    # @raise [NameError] if the class doesn't exist
    def expected_class
      ::Object.const_get(@expected)
    end
  end
end
