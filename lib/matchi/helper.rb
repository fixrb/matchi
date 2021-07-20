# frozen_string_literal: true

require_relative "matcher"

module Matchi
  # When included, this module defines a helper instance method per matcher.
  #
  # @example Define and use the dynamic helper instance method of a custom matcher
  #   require "matchi/matcher/base"
  #
  #   module Matchi
  #     module Matcher
  #       class BeTheAnswer < ::Matchi::Matcher::Base
  #         def matches?
  #           42.equal?(yield)
  #         end
  #       end
  #     end
  #   end
  #
  #   require "matchi/helper"
  #
  #   class MatcherBase
  #     include ::Matchi::Helper
  #   end
  #
  #   matcher_base = MatcherBase.new
  #   matcher_base.be_the_answer.matches? { 42 } # => true
  module Helper
    ::Matchi::Matcher.constants.each do |matcher_const|
      next if matcher_const.equal?(:Base)

      matcher_klass = ::Matchi::Matcher.const_get(matcher_const)

      define_method(matcher_klass.to_sym) do |*args, **kwargs, &block|
        matcher_klass.new(*args, **kwargs, &block)
      end
    end
  end
end
