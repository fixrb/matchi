# frozen_string_literal: true

module Matchi
  # Predicate matcher that checks if an object responds to a predicate method with a truthy value.
  #
  # This matcher converts a predicate name (starting with 'be_' or 'have_') into a method call
  # ending with '?' and verifies that calling this method returns a boolean value. It's useful
  # for testing state-checking methods and collection properties. The matcher supports two types
  # of predicate formats: 'be_*' which converts to '*?' and 'have_*' which converts to 'has_*?'.
  #
  # @example Basic empty check
  #   matcher = Matchi::Predicate.new(:be_empty)
  #   matcher.match? { [] }        # => true
  #   matcher.match? { [1, 2] }    # => false
  #
  # @example Object property check with arguments
  #   matcher = Matchi::Predicate.new(:have_key, :name)
  #   matcher.match? { { name: "Alice" } }  # => true
  #   matcher.match? { { age: 30 } }        # => false
  #
  # @example Using keyword arguments
  #   class Record
  #     def complete?(status: nil)
  #       status.nil? || status == :validated
  #     end
  #   end
  #
  #   matcher = Matchi::Predicate.new(:be_complete, status: :validated)
  #   matcher.match? { Record.new }  # => true
  #
  # @example With block arguments
  #   class List
  #     def all?(&block)
  #       block ? super : empty?
  #     end
  #   end
  #
  #   matcher = Matchi::Predicate.new(:be_all) { |x| x.positive? }
  #   matcher.match? { [1, 2, 3] }    # => true
  #   matcher.match? { [-1, 2, 3] }   # => false
  #
  # @see https://ruby-doc.org/core/Object.html#method-i-respond_to-3F
  class Predicate
    # Mapping of predicate prefixes to their method name transformations.
    # Each entry defines how a prefix should be converted to its method form.
    #
    # @api private
    PREFIXES = {
      "be_"   => ->(name) { "#{name.gsub(/\A(?:be_)/, "")}?" },
      "have_" => ->(name) { "#{name.gsub(/\A(?:have_)/, "has_")}?" }
    }.freeze

    # Initialize the matcher with a predicate name and optional arguments.
    #
    # @api public
    #
    # @param name [#to_s] A matcher name starting with 'be_' or 'have_'
    # @param args [Array] Optional positional arguments to pass to the predicate method
    # @param kwargs [Hash] Optional keyword arguments to pass to the predicate method
    # @param block [Proc] Optional block to pass to the predicate method
    #
    # @raise [ArgumentError] if the predicate name format is invalid
    #
    # @return [Predicate] a new instance of the matcher
    #
    # @example With simple predicate
    #   Predicate.new(:be_empty)                # Empty check
    #
    # @example With arguments
    #   Predicate.new(:have_key, :id)           # Key presence check
    #
    # @example With keyword arguments
    #   Predicate.new(:be_valid, status: true)  # Conditional validation
    def initialize(name, *args, **kwargs, &block)
      @name = String(name)
      raise ::ArgumentError, "invalid predicate name format" unless valid_name?

      @args = args
      @kwargs = kwargs
      @block = block
    end

    # Checks if the yielded object responds to and returns true for the predicate.
    #
    # This method converts the predicate name into a method name according to the prefix
    # mapping and calls it on the yielded object with any provided arguments. The method
    # must return a boolean value, or a TypeError will be raised.
    #
    # @api public
    #
    # @yield [] Block that returns the object to check
    # @yieldreturn [Object] The object to call the predicate method on
    #
    # @return [Boolean] true if the predicate method returns true
    #
    # @raise [ArgumentError] if no block is provided
    # @raise [TypeError] if predicate method returns non-boolean value
    #
    # @example Basic usage
    #   matcher = Predicate.new(:be_empty)
    #   matcher.match? { [] }                # => true
    #   matcher.match? { [1] }               # => false
    #
    # @example With arguments
    #   matcher = Predicate.new(:have_key, :id)
    #   matcher.match? { { id: 1 } }         # => true
    def match?
      raise ::ArgumentError, "a block must be provided" unless block_given?

      value = yield.send(method_name, *@args, **@kwargs, &@block)
      return value if [false, true].include?(value)

      raise ::TypeError, "Boolean expected, but #{value.class} instance returned."
    end

    # Returns a human-readable description of the matcher.
    #
    # @api public
    #
    # @return [String] A string describing what this matcher verifies
    #
    # @example Simple predicate
    #   Predicate.new(:be_empty).to_s                # => "be empty"
    #
    # @example With arguments
    #   Predicate.new(:have_key, :id).to_s           # => "have key :id"
    #
    # @example With keyword arguments
    #   Predicate.new(:be_valid, active: true).to_s  # => "be valid active: true"
    def to_s
      (
        "#{@name.tr("_", " ")} " + [
          @args.map(&:inspect).join(", "),
          @kwargs.map { |k, v| "#{k}: #{v.inspect}" }.join(", "),
          (@block.nil? ? "" : "&block")
        ].reject { |i| i.eql?("") }.join(", ")
      ).strip
    end

    private

    # Converts the predicate name into the actual method name to call.
    #
    # @api private
    #
    # @return [Symbol] The method name to call on the object
    # @raise [ArgumentError] if the predicate prefix is unknown
    #
    # @example
    #   # With be_ prefix
    #   method_name                   # => :empty? (from be_empty)
    #   # With have_ prefix
    #   method_name                   # => :has_key? (from have_key)
    def method_name
      _, transform = PREFIXES.find { |prefix, _| @name.start_with?(prefix) }
      return transform.call(@name) if transform

      raise ::ArgumentError, "unknown prefix in predicate name: #{@name}"
    end

    # Verifies that the predicate name follows the required format.
    #
    # @api private
    #
    # @return [Boolean] true if the name follows the required format
    def valid_name?
      return false if @name.match?(/[?!]\z/)

      PREFIXES.keys.any? { |prefix| @name.start_with?(prefix) }
    end
  end
end
