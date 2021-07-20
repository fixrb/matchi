# frozen_string_literal: true

require_relative "base"

module Matchi
  module Matcher
    # *Type/class* matcher.
    class BeAnInstanceOf < ::Matchi::Matcher::Base
      # Initialize the matcher with an object.
      #
      # @example A duck matcher
      #   Matchi::Matcher::BeAnInstanceOf.new(:Duck)
      #
      # @param expected [#to_s] The name of a module.
      def initialize(expected)
        super()
        @expected = String(expected).to_sym
      end

      # (see Base#inspect)
      def inspect
        "#{self.class}(#{expected})"
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
        self.class.const_get(expected).equal?(yield.class)
      end

      # (see Base#to_s)
      def to_s
        "#{self.class.to_sym} #{expected}"
      end
    end
  end
end
