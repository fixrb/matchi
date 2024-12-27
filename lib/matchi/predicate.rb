# frozen_string_literal: true

module Matchi
  # *Predicate* matcher.
  class Predicate
    # Initialize the matcher with a name and arguments.
    #
    # @example
    #   require "matchi/predicate"
    #
    #   Matchi::Predicate.new(:be_empty)
    #
    # @param name   [#to_s] A matcher name.
    # @param args   [Array] A list of parameters.
    # @param kwargs [Hash]  A list of keyword parameters.
    # @param block  [Proc]  A block of code.
    def initialize(name, *args, **kwargs, &block)
      @name = String(name)

      raise ::ArgumentError unless valid_name?

      @args   = args
      @kwargs = kwargs
      @block  = block
    end

    # Boolean comparison between the actual value and the expected value.
    #
    # @example
    #   require "matchi/predicate"
    #
    #   matcher = Matchi::Predicate.new(:be_empty)
    #   matcher.match? { [] } # => true
    #
    # @example
    #   require "matchi/predicate"
    #
    #   matcher = Matchi::Predicate.new(:have_key, :foo)
    #   matcher.match? { { foo: 42 } } # => true
    #
    # @yieldreturn [#object_id] The actual value to receive the method request.
    #
    # @return [Boolean] A boolean returned by the actual value being tested.
    def match?
      value = yield.send(method_name, *@args, **@kwargs, &@block)
      return value if [false, true].include?(value)

      raise ::TypeError, "Boolean expected, but #{value.class} instance returned."
    end

    # A string containing a human-readable representation of the matcher.
    def inspect
      "#{self.class}(#{@name}, *#{@args.inspect}, **#{@kwargs.inspect}, &#{@block.inspect})"
    end

    # Returns a string representing the matcher.
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

    # The name of the method to send to the object.
    def method_name
      if @name.start_with?("be_")
        :"#{@name.gsub("be_", "")}?"
      else
        :"#{@name.gsub("have_", "has_")}?"
      end
    end

    # Verify the matcher name structure.
    def valid_name?
      return false if @name.end_with?("?", "!")

      @name.start_with?("be_", "have_")
    end
  end
end
