# frozen_string_literal: true

module Matchi
  module Matcher
    # Abstract matcher class.
    class Base
      # Returns a symbol identifying the matcher.
      #
      # @example The readable definition of a FooBar matcher class.
      #   matcher_class = Matchi::Matcher::FooBar
      #   matcher_class.to_sym # => "foo_bar"
      #
      # @return [Symbol] A symbol identifying the matcher.
      def self.to_sym
        name.split("::")
            .fetch(-1)
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
            .to_sym
      end

      # @return [#object_id] Any value to give to the matcher.
      attr_reader :expected

      # A string containing a human-readable representation of the matcher.
      #
      # @example The human-readable representation of a FooBar matcher instance.
      #   matcher = Matchi::Matcher::FooBar.new(42)
      #   matcher.inspect # => "Matchi::Matcher::FooBar(42)"
      #
      # @return [String] The human-readable representation of the matcher.
      def inspect
        "#{self.class}(#{expected&.inspect})"
      end

      # Abstract matcher class.
      #
      # @example Test the equivalence between two "foo" strings.
      #   eql = Matchi::Matcher::Eql.new("foo")
      #   eql.matches? { "foo" } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @raise [NotImplementedError] Override this method inside a matcher.
      def matches?
        raise ::NotImplementedError, "matcher MUST respond to this method."
      end

      # Returns a string representing the matcher instance.
      #
      # @example The readable definition of a FooBar matcher instance.
      #   matcher = Matchi::Matcher::FooBar.new(42)
      #   matcher.to_s # => "foo_bar 42"
      #
      # @return [String] A string representing the matcher instance.
      def to_s
        [self.class.to_sym, expected&.inspect].compact.join(" ")
      end
    end
  end
end
