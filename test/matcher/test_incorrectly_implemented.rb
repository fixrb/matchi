# frozen_string_literal: true

require_relative File.join('..', 'support', 'coverage')
require_relative File.join('..', '..', 'lib', 'matchi', 'matcher', 'base')

module Matchi
  module Matcher
    # An incorrectly implemented matcher.
    class IncorrectlyImplemented < ::Matchi::Matcher::Base
      # @note The `matches?` method is missing.
    end
  end
end

expected = nil
matcher = Matchi::Matcher::IncorrectlyImplemented.new(expected)

# It is expected to raise NotImplementedError
begin
  matcher.matches? { 42 } && raise('A NotImplementedError was expected.')
rescue NotImplementedError => e
  e # => A not implemented error has been raised, as expected.
end
