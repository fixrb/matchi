# frozen_string_literal: true

require_relative "matcher"

module Matchi
  # Collection of helper methods.
  module Helper
    ::Matchi::Matcher.constants.each do |matcher_const|
      next if matcher_const.equal?(:Base)

      matcher_klass = ::Matchi::Matcher.const_get(matcher_const)

      # Define a method for the given matcher.
      #
      # @example Given the `Matchi::Matchers::Equal::Matcher` matcher, its
      #   method would be:
      #
      #   def equal(expected)
      #     Matchi::Matchers::Equal::Matcher.new(expected)
      #   end
      #
      # @return [#matches?] The matcher.
      define_method(matcher_klass.to_sym) do |*args|
        matcher_klass.new(*args)
      end
    end
  end
end
