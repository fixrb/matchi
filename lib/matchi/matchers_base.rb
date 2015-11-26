module Matchi
  # Common matcher methods.
  module MatchersBase
    # Abstract matcher class.
    #
    # @raise [NotImplementedError] Override me inside a Matcher subclass please.
    def matches?
      fail NotImplementedError, 'The matcher MUST respond to matches? method.'
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::Matchers::FooBar::Matcher.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      s = matcher_name
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase

      defined?(@expected) ? [s, @expected.inspect].join(' ') : s
    end

    # Returns a hash of one key-value pair with a key corresponding to the
    #   matcher and a value corresponding to its initialize parameters.
    #
    # @example A FooBar matcher serialized into a hash.
    #   matcher = Matchi::Matchers::FooBar::Matcher.new(42)
    #   matcher.to_h # => { FooBar: 42 }
    #
    # @return [Hash] A hash of one key-value pair.
    def to_h
      { matcher_name.to_sym => (defined?(@expected) ? Array(@expected) : []) }
    end

    private

    def matcher_name
      self
        .class
        .name
        .gsub(/^Matchi::Matchers::/, '')
        .gsub(/::Matcher$/, '')
    end
  end
end
