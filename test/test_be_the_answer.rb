require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

module Matchi
  # **Answer to the Ultimate Question of Life, The Universe, and Everything**
  # matcher.
  class BeTheAnswer
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
  end
end

# It is expected to be true
fail unless Matchi.fetch(:BeTheAnswer).matches? { 42 }

# It is expected to be false
fail if Matchi.fetch(:BeTheAnswer).matches? { 4 }
