# frozen_string_literal: true

module Matchi
  # *Type/class* matcher with enhanced class checking.
  #
  # This matcher aims to provide a more reliable way to check if an object is an exact
  # instance of a specific class (not a subclass). While not foolproof, it uses a more
  # robust method to get the actual class of an object that helps resist common
  # attempts at type checking manipulation.
  #
  # @example Basic usage
  #   require "matchi/be_an_instance_of"
  #
  #   matcher = Matchi::BeAnInstanceOf.new(String)
  #   matcher.match? { "foo" }  # => true
  #   matcher.match? { :foo }   # => false
  #
  # @example Enhanced class checking in practice
  #   # Consider a class that attempts to masquerade as String by overriding
  #   # common type checking methods:
  #   class MaliciousString
  #     def class
  #       ::String
  #     end
  #
  #     def instance_of?(klass)
  #       self.class == klass
  #     end
  #
  #     def is_a?(klass)
  #       "".is_a?(klass)  # Delegates to a real String
  #     end
  #
  #     def kind_of?(klass)
  #       is_a?(klass)     # Maintains Ruby's kind_of? alias for is_a?
  #     end
  #   end
  #
  #   obj = MaliciousString.new
  #   obj.class                                             # => String
  #   obj.is_a?(String)                                     # => true
  #   obj.kind_of?(String)                                  # => true
  #   obj.instance_of?(String)                              # => true
  #
  #   # Using our enhanced checking approach:
  #   matcher = Matchi::BeAnInstanceOf.new(String)
  #   matcher.match? { obj }                                # => false
  class BeAnInstanceOf
    # Initialize the matcher with (the name of) a class or module.
    #
    # @example
    #   require "matchi/be_an_instance_of"
    #
    #   Matchi::BeAnInstanceOf.new(String)
    #   Matchi::BeAnInstanceOf.new("String")
    #   Matchi::BeAnInstanceOf.new(:String)
    #
    # @param expected [Class, #to_s] The expected class name
    # @raise [ArgumentError] if the class name doesn't start with an uppercase letter
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ::ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Securely checks if the yielded object is an instance of the expected class.
    #
    # This method uses a specific Ruby reflection technique to get the true class of
    # an object, bypassing potential method overrides:
    #
    # 1. ::Object.instance_method(:class) retrieves the original, unoverridden 'class'
    #    method from the Object class
    # 2. .bind_call(obj) binds this original method to our object and calls it,
    #    ensuring we get the real class regardless of method overrides
    #
    # This approach is more reliable than obj.class because it uses Ruby's method
    # binding mechanism to call the original implementation directly. While not
    # completely foolproof, it provides better protection against type check spoofing
    # than using regular method calls which can be overridden.
    #
    # @example Basic class check
    #   matcher = Matchi::BeAnInstanceOf.new(String)
    #   matcher.match? { "test" }        # => true
    #   matcher.match? { StringIO.new }  # => false
    #
    # @see https://ruby-doc.org/core/Method.html#method-i-bind_call
    # @see https://ruby-doc.org/core/UnboundMethod.html
    #
    # @yieldreturn [Object] the actual value to check
    # @return [Boolean] true if the object's actual class is exactly the expected class
    # @raise [ArgumentError] if no block is provided
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      actual_class = ::Object.instance_method(:class).bind_call(yield)
      expected_class == actual_class
    end

    # Returns a string representing the matcher.
    #
    # @return [String] a human-readable description of the matcher
    def to_s
      "be an instance of #{@expected}"
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
