# frozen_string_literal: true

require_relative File.join 'support', 'coverage'

module Matchi
  module Matchers
    # **Answer to the Ultimate Question of Life, The Universe, and Everything**
    # matcher.
    module BeTheAnswer
      # The matcher.
      class Matcher
        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it 42?
        #   be_the_answer = Matchi::Matchers::BeTheAnswer.new
        #   be_the_answer.matches? { 42 } # => true
        #
        # @yieldreturn [#object_id] the actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?
          42.equal? yield
        end

        # Returns a string representing the matcher.
        #
        # @example The readable definition of a BeTheAnswer matcher.
        #   matcher = Matchi::Matchers::BeTheAnswer::Matcher.new
        #   matcher.to_s # => "be_the_answer"
        #
        # @return [String] A string representing the matcher.
        def to_s
          'be_the_answer'
        end

        # Returns a hash of one key-value pair with a key corresponding to the
        #   matcher and a value corresponding to its initialize parameters.
        #
        # @example A BeTheAnswer matcher serialized into a hash.
        #   matcher = Matchi::Matchers::BeTheAnswer::Matcher.new
        #   matcher.to_h # => { BeTheAnswer: [] }
        #
        # @return [Hash] A hash of one key-value pair.
        def to_h
          { BeTheAnswer: [] }
        end
      end
    end
  end
end

matcher = Matchi::Matchers::BeTheAnswer::Matcher.new

# It is expected to be true
raise unless matcher.matches? { 42 }

# It is expected to be false
raise if matcher.matches? { 4 }

# It returns this string
raise unless matcher.to_s == 'be_the_answer'

# It returns this hash
raise unless matcher.to_h == { BeTheAnswer: [] }
