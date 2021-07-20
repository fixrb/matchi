# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "helper")

# Test helper methods of built-in matchers

class Sandbox
  include ::Matchi::Helper
end

sandbox = Sandbox.new

raise unless sandbox.be_an_instance_of(:String).matches? { "foo" }
raise unless sandbox.be_false.matches? { false }
raise unless sandbox.be_nil.matches? { nil }
raise unless sandbox.be_true.matches? { true }
raise unless sandbox.eql(42).matches? { 42 }
raise unless sandbox.equal(42).matches? { 42 }
raise unless sandbox.match(/^foo/).matches? { "foobar" }
raise unless sandbox.raise_exception(NameError).matches? { Matchi::Boom }
raise unless sandbox.satisfy { |value| value == "foo" }.matches? { "foo" }

# Test helper methods of custom matchers

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

load "matchi/helper.rb"

class Sandbox
  include ::Matchi::Helper
end

sandbox = Sandbox.new

raise unless sandbox.be_the_answer.matches? { 42 }
