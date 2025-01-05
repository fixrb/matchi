# frozen_string_literal: true

module Matchi
  # Exception matcher that verifies if a block of code raises a specific exception.
  #
  # This matcher ensures that code raises an expected exception by executing it within
  # a controlled environment. It supports matching against specific exception classes
  # and their subclasses, providing a reliable way to test error handling.
  #
  # @example Basic usage with standard exceptions
  #   matcher = Matchi::RaiseException.new(ArgumentError)
  #   matcher.match? { raise ArgumentError }    # => true
  #   matcher.match? { raise RuntimeError }     # => false
  #   matcher.match? { "no error" }             # => false
  #
  # @example Working with inheritance hierarchy
  #   class CustomError < StandardError; end
  #   class SpecificError < CustomError; end
  #
  #   matcher = Matchi::RaiseException.new(CustomError)
  #   matcher.match? { raise CustomError }      # => true
  #   matcher.match? { raise SpecificError }    # => true
  #   matcher.match? { raise StandardError }    # => false
  #
  # @example Using string class names
  #   matcher = Matchi::RaiseException.new("ArgumentError")
  #   matcher.match? { raise ArgumentError }    # => true
  #
  # @example With custom exception hierarchies
  #   module Api
  #     class Error < StandardError; end
  #     class AuthenticationError < Error; end
  #   end
  #
  #   matcher = Matchi::RaiseException.new("Api::Error")
  #   matcher.match? { raise Api::AuthenticationError } # => true
  #
  # @see https://ruby-doc.org/core/Exception.html
  # @see https://ruby-doc.org/core/StandardError.html
  class RaiseException
    # Initialize the matcher with an exception class.
    #
    # @api public
    #
    # @param expected [Exception, #to_s] The expected exception class or its name
    #   Can be provided as a Class, String, or Symbol
    #
    # @raise [ArgumentError] if the class name doesn't start with an uppercase letter
    #
    # @return [RaiseException] a new instance of the matcher
    #
    # @example
    #   RaiseException.new(ArgumentError)         # Using class
    #   RaiseException.new("ArgumentError")       # Using string
    #   RaiseException.new(:ArgumentError)        # Using symbol
    #   RaiseException.new("Api::CustomError")    # Using namespaced class
    def initialize(expected)
      @expected = String(expected)
      return if /\A[A-Z]/.match?(@expected)

      raise ::ArgumentError,
            "expected must start with an uppercase letter (got: #{@expected})"
    end

    # Checks if the yielded block raises the expected exception.
    #
    # This method executes the provided block within a begin/rescue clause and verifies
    # that it raises an exception of the expected type. It also handles inheritance,
    # allowing subclasses of the expected exception to match.
    #
    # @api public
    #
    # @yield [] Block that should raise an exception
    # @yieldreturn [Object] The result of the block (if it doesn't raise)
    #
    # @return [Boolean] true if the block raises the expected exception
    #
    # @raise [ArgumentError] if no block is provided
    # @raise [ArgumentError] if expected exception class doesn't inherit from Exception
    # @raise [NameError] if the expected exception class cannot be found
    #
    # @example Standard usage
    #   matcher = RaiseException.new(ArgumentError)
    #   matcher.match? { raise ArgumentError }     # => true
    #
    # @example With inheritance
    #   matcher = RaiseException.new(StandardError)
    #   matcher.match? { raise ArgumentError }     # => true
    #
    # @example Without exception
    #   matcher = RaiseException.new(StandardError)
    #   matcher.match? { "no error" }             # => false
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      klass = expected_class
      raise ::ArgumentError, "expected exception class must inherit from Exception" unless klass <= ::Exception

      begin
        yield
        false
      rescue ::Exception => e # rubocop:disable Lint/RescueException
        e.class <= klass
      end
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example
    #   RaiseException.new(ArgumentError).to_s  # => "raise exception ArgumentError"
    def to_s
      "raise exception #{@expected}"
    end

    private

    # Resolves the expected class name to an actual Exception class.
    #
    # @api private
    #
    # @return [Class] The resolved exception class
    # @raise [NameError] If the class name cannot be resolved to an actual class
    #
    # @note This method handles both string and symbol class names through constant resolution
    def expected_class
      ::Object.const_get(@expected)
    end
  end
end
