require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

module Matchi
  # **Answer to the Ultimate Question of Life, The Universe, and Everything**
  # matcher.
  class BeTheAnswer
    # Boolean comparison between the actual value and the expected value.
    #
    # @example Is it 42?
    #   be_the_answer = Matchi::BeTheAnswer.new
    #   be_the_answer.matches? { 42 } # => true
    #
    # @yieldreturn [#object_id] the actual value to compare to the expected one.
    #
    # @return [Boolean] Comparison between actual and expected values.
    def matches?
      42.equal? yield
    end

    # Returns a string representing the matcher.
    #
    # @example The readable definition of a FooBar matcher.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_s # => "foo_bar 42"
    #
    # @return [String] A string representing the matcher.
    def to_s
      'be_the_answer'
    end

    # Returns a hash of one key-value pair with a key corresponding to the
    #   matcher and a value corresponding to its initialize parameters.
    #
    # @example A FooBar matcher serialized into a hash.
    #   matcher = Matchi::FooBar.new(42)
    #   matcher.to_h # => { FooBar: 42 }
    #
    # @return [Hash] A hash of one key-value pair.
    def to_h
      { BeTheAnswer: [] }
    end
  end
end

matcher = Matchi::BeTheAnswer.new

# It is expected to be true
fail unless matcher.matches? { 42 }

# It is expected to be false
fail if matcher.matches? { 4 }

# It returns this string
fail unless matcher.to_s == 'be_the_answer'

# It returns this hash
fail unless matcher.to_h == { BeTheAnswer: [] }
