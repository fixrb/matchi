# frozen_string_literal: true

module Matchi
  # Type matcher that checks if an object is an exact instance of a specific class.
  #
  # This matcher provides a secure way to verify an object's exact type, ensuring it
  # matches a specific class without including subclasses. It uses Ruby's method binding
  # mechanism to bypass potential method overrides, providing better protection against
  # type check spoofing than standard instance_of? checks.
  #
  # @example Basic usage
  #   matcher = Matchi::BeAnInstanceOf.new(String)
  #   matcher.match? { "test" }      # => true
  #   matcher.match? { :test }       # => false
  #
  # @example Inheritance behavior
  #   class Animal; end
  #   class Dog < Animal; end
  #
  #   matcher = Matchi::BeAnInstanceOf.new(Animal)
  #   matcher.match? { Animal.new }  # => true
  #   matcher.match? { Dog.new }     # => false  # Subclass doesn't match
  #
  # @example Secure type checking
  #   # Consider a class that attempts to masquerade as String:
  #   class MaliciousString
  #     def class; String; end
  #     def instance_of?(klass); true; end
  #   end
  #
  #   obj = MaliciousString.new
  #   obj.instance_of?(String)                           # => true (spoofed)
  #
  #   matcher = Matchi::BeAnInstanceOf.new(String)
  #   matcher.match? { obj }                             # => false (secure)
  #
  # @example Different ways to specify the class
  #   # Using class directly
  #   Matchi::BeAnInstanceOf.new(String)
  #
  #   # Using class name as string
  #   Matchi::BeAnInstanceOf.new("String")
  #
  #   # Using class name as symbol
  #   Matchi::BeAnInstanceOf.new(:String)
  #
  #   # Using namespaced class
  #   Matchi::BeAnInstanceOf.new("MyModule::MyClass")
  #
  # @see Matchi::BeAKindOf
  # @see https://ruby-doc.org/core/Object.html#method-i-instance_of-3F
  # @see https://ruby-doc.org/core/Module.html#method-i-bind_call
  class BeAnInstanceOf
    # Initialize the matcher with (the name of) a class or module.
    #
    # @api public
    #
    # @param expected [Class, #to_s] The expected class or its name
    #   Can be provided as a Class object, String, or Symbol
    #
    # @raise [ArgumentError] if the class name doesn't start with an uppercase letter
    #
    # @return [BeAnInstanceOf] a new instance of the matcher
    #
    # @example
    #   BeAnInstanceOf.new(String)          # Using class
    #   BeAnInstanceOf.new("String")        # Using string
    #   BeAnInstanceOf.new(:String)         # Using symbol
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ::ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Securely checks if the yielded object is an instance of the expected class.
    #
    # This method uses Ruby's method binding mechanism to get the true class of an object,
    # bypassing potential method overrides. While not completely foolproof, it provides
    # better protection against type check spoofing than using regular method calls which
    # can be overridden.
    #
    # @api public
    #
    # @yield [] Block that returns the object to check
    # @yieldreturn [Object] The object to verify the type of
    #
    # @return [Boolean] true if the object's actual class is exactly the expected class
    #
    # @raise [ArgumentError] if no block is provided
    # @raise [NameError] if the expected class cannot be found
    #
    # @example Simple type check
    #   matcher = BeAnInstanceOf.new(String)
    #   matcher.match? { "test" }        # => true
    #   matcher.match? { StringIO.new }  # => false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      actual_class = ::Object.instance_method(:class).bind_call(yield)
      expected_class == actual_class
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   BeAnInstanceOf.new(String).to_s # => "be an instance of String"
    def to_s
      "be an instance of #{@expected}"
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
