# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Type/class* matcher.
    class BeAnInstanceOf < ::Matchi::Matcher::Base
      # Initialize the matcher with an object.
      #
      # @example A string matcher
      #   Matchi::Matcher::BeAnInstanceOf.new(String)
      #
      # @param expected [#to_s] The name of a module.
      def initialize(expected)
        super()
        @expected = self.class.const_get String(expected)
      end

      # Boolean comparison between the class of the actual value and the
      # expected class.
      #
      # @example Is it an instance of string?
      #   be_an_instance_of = Matchi::Matcher::BeInstanceOf.new(String)
      #   be_an_instance_of.matches? { "foo" } # => true
      #
      #   be_an_instance_of = Matchi::Matcher::BeInstanceOf.new(:String)
      #   be_an_instance_of.matches? { "foo" } # => true
      #
      #   be_an_instance_of = Matchi::Matcher::BeInstanceOf.new("String")
      #   be_an_instance_of.matches? { "foo" } # => true
      #
      # @yieldreturn [#class] the actual value to compare to the expected one.
      #
      # @return [Boolean] Comparison between actual and expected values.
      def matches?(*, **)
        expected.equal?(yield.class)
      end
    end
  end
end
