# frozen_string_literal: true

require_relative ::File.join('..', 'matchers_base') unless
  defined?(::Matchi::MatchersBase)

module Matchi
  module Matchers
    # **Expecting errors** matcher.
    module RaiseException
      # The matcher.
      class Matcher
        include MatchersBase

        # Initialize the matcher with a descendant of class Exception.
        #
        # @example Divided by 0 matcher.
        #   Matchi::Matchers::RaiseException::Matcher.new(ZeroDivisionError)
        #
        # @param expected [.exception] The class of the expected exception.
        def initialize(expected)
          @expected = expected
        end

        # Boolean comparison between the actual value and the expected value.
        #
        # @example Is it raising NameError?
        #   matcher = Matchi::Matchers::RaiseException::Matcher.new(NameError)
        #   matcher.matches? { Boom } # => true
        #
        # @yieldreturn [#object_id] the actual value to compare to the expected
        #   one.
        #
        # @return [Boolean] Comparison between actual and expected values.
        def matches?
          yield
        rescue @expected
          true
        else
          false
        end
      end
    end
  end
end
