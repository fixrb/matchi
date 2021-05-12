# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")

module Matchi
  module Matcher
    # **Answer to the Ultimate Question of Life, The Universe, and Everything**
    # matcher.
    class BeTheAnswer < ::Matchi::Matcher::Base
      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it 42?
      #   be_the_answer = Matchi::Matcher::BeTheAnswer.new
      #   be_the_answer.matches? { 42 } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?
        42.equal? yield
      end
    end
  end
end

expected = nil
matcher = Matchi::Matcher::BeTheAnswer.new

# It returns the symbol
raise unless matcher.class.to_sym == :be_the_answer

# It is expected to be true
raise unless matcher.matches? { 42 }

# It is expected to be false
raise if matcher.matches? { 4 }

# It returns this string
raise unless matcher.to_s == "be_the_answer"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::BeTheAnswer()"

# It returns an expected given value
raise unless matcher.expected == expected
