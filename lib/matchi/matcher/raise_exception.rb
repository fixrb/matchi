# frozen_string_literal: true

require_relative 'base'

module Matchi
  module Matcher
    # **Expecting errors** matcher.
    class RaiseException < ::Matchi::Matcher::Base
      # Initialize the matcher with a descendant of class Exception.
      #
      # @example Divided by 0 matcher.
      #   Matchi::Matcher::RaiseException.new(ZeroDivisionError)
      #
      # @param expected [Exception] The class of the expected exception.
      def initialize(expected)
        @expected = expected
      end

      # Boolean comparison between the actual value and the expected value.
      #
      # @example Is it raising NameError?
      #   matcher = Matchi::Matcher::RaiseException.new(NameError)
      #   matcher.matches? { Boom } # => true
      #
      # @yieldreturn [#object_id] The actual value to compare to the expected
      #   one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        yield
      rescue expected => _e
        true
      else
        false
      end
    end
  end
end
