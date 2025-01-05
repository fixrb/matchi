# frozen_string_literal: true

module Matchi
  # Type matcher that checks if an object is an instance of a class or one of its subclasses.
  #
  # This matcher provides a reliable way to verify object types while respecting Ruby's
  # inheritance hierarchy. It uses the case equality operator (===) which is Ruby's
  # built-in mechanism for type checking, ensuring consistent behavior with Ruby's
  # own type system.
  #
  # @example Basic usage with simple types
  #   matcher = Matchi::BeAKindOf.new(Numeric)
  #   matcher.match? { 42 }     # => true
  #   matcher.match? { 42.0 }   # => true
  #   matcher.match? { "42" }   # => false
  #
  # @example Working with inheritance hierarchies
  #   class Animal; end
  #   class Dog < Animal; end
  #   class GermanShepherd < Dog; end
  #
  #   matcher = Matchi::BeAKindOf.new(Animal)
  #   matcher.match? { Dog.new }             # => true
  #   matcher.match? { GermanShepherd.new }  # => true
  #   matcher.match? { Object.new }          # => false
  #
  # @example Using with modules and interfaces
  #   module Swimmable
  #     def swim; end
  #   end
  #
  #   class Duck
  #     include Swimmable
  #   end
  #
  #   matcher = Matchi::BeAKindOf.new(Swimmable)
  #   matcher.match? { Duck.new }     # => true
  #   matcher.match? { Object.new }   # => false
  #
  # @example Different ways to specify the class
  #   # Using class directly
  #   Matchi::BeAKindOf.new(String)
  #
  #   # Using class name as string
  #   Matchi::BeAKindOf.new("String")
  #
  #   # Using class name as symbol
  #   Matchi::BeAKindOf.new(:String)
  #
  #   # Using namespaced class
  #   Matchi::BeAKindOf.new("MyModule::MyClass")
  #
  # @see Matchi::BeAnInstanceOf
  # @see https://ruby-doc.org/core/Module.html#method-i-3D-3D-3D
  class BeAKindOf
    # Creates a new type matcher for the specified class.
    #
    # @api public
    #
    # @param expected [Class, #to_s] The expected class or its name
    #   Can be provided as a Class object, String, or Symbol
    #
    # @raise [ArgumentError] if the class name doesn't start with an uppercase letter
    #
    # @return [BeAKindOf] a new instance of the matcher
    #
    # @example
    #   BeAKindOf.new(String)          # Using class
    #   BeAKindOf.new("String")        # Using string
    #   BeAKindOf.new(:String)         # Using symbol
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Checks if the yielded object is an instance of the expected class or its subclasses.
    #
    # This method leverages Ruby's case equality operator (===) which provides a reliable
    # way to check class hierarchy relationships. When a class is the receiver of ===,
    # it returns true if the argument is an instance of that class or one of its subclasses.
    #
    # @api public
    #
    # @yield [] Block that returns the object to check
    # @yieldreturn [Object] The object to verify the type of
    #
    # @return [Boolean] true if the object is an instance of the expected class or one of its subclasses
    #
    # @raise [ArgumentError] if no block is provided
    # @raise [NameError] if the expected class cannot be found
    #
    # @example Simple type check
    #   matcher = BeAKindOf.new(Numeric)
    #   matcher.match? { 42 }      # => true
    #
    # @example With inheritance
    #   matcher = BeAKindOf.new(Animal)
    #   matcher.match? { Dog.new } # => true
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      expected_class === yield # rubocop:disable Style/CaseEquality
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   BeAKindOf.new(String).to_s # => "be a kind of String"
    def to_s
      "be a kind of #{@expected}"
    end

    private

    # Resolves the expected class name to an actual Class object.
    #
    # @api private
    #
    # @return [Class] The resolved class object
    # @raise [NameError] If the class name cannot be resolved to an actual class
    #
    # @note This method handles both string and symbol class names through constant resolution
    def expected_class
      ::Object.const_get(@expected)
    end
  end
end
