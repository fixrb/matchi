# frozen_string_literal: true

module Matchi
  module Matcher
    # Abstract matcher class.
    class Base
      # @return [Symbol] A symbol identifying the matcher.
      def self.to_sym
        name.delete_prefix("Matchi::Matcher::")
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
            .to_sym
      end

      # @return [#object_id] Any value to give to the matcher.
      attr_reader :expected

      # A string containing a human-readable representation of the matcher.
      #
      # @return [String] The human-readable representation of the matcher.
      def inspect
        "#{self.class}(#{expected&.inspect})"
      end

      # Abstract matcher class.
      #
      # @raise [NotImplementedError] Override me inside a matcher.
      def matches?
        raise ::NotImplementedError, "matcher MUST respond to this method."
      end

      # Returns a string representing the matcher.
      #
      # @example The readable definition of a FooBar matcher.
      #   matcher = Matchi::Matcher::FooBar.new(42)
      #   matcher.to_s # => "foo_bar 42"
      #
      # @return [String] A string representing the matcher.
      def to_s
        [self.class.to_sym, expected&.inspect].compact.join(" ")
      end
    end
  end
end
