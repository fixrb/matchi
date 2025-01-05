# frozen_string_literal: true

# Main namespace for the Matchi gem, providing a collection of expectation matchers.
#
# Matchi is a framework-agnostic Ruby library that offers a comprehensive set of
# matchers for testing and verification purposes. Each matcher follows a consistent
# interface pattern, making them easy to use and extend.
#
# @example Basic usage with equality matcher
#   Matchi::Eq.new("hello").match? { "hello" }     # => true
#   Matchi::Eq.new("hello").match? { "world" }     # => false
#
# @example Type checking with inheritance awareness
#   Matchi::BeAKindOf.new(Numeric).match? { 42 }   # => true
#   Matchi::BeAKindOf.new(String).match? { 42 }    # => false
#
# @example Verifying state changes
#   array = []
#   Matchi::Change.new(array, :length).by(2).match? { array.push(1, 2) }  # => true
#
# @example Pattern matching with regular expressions
#   Matchi::Match.new(/^test/).match? { "test_string" }  # => true
#
# Each matcher in the Matchi ecosystem implements a consistent interface:
# - An initializer that sets up the expected values or conditions
# - A #match? method that takes a block and returns a boolean
# - An optional #to_s method that provides a human-readable description
#
# @example Creating a custom matcher
#   module Matchi
#     class BePositive
#       def match?
#         raise ArgumentError, "a block must be provided" unless block_given?
#         yield.positive?
#       end
#
#       def to_s
#         "be positive"
#       end
#     end
#   end
#
# @see Matchi::Be
# @see Matchi::BeAKindOf
# @see Matchi::BeAnInstanceOf
# @see Matchi::BeWithin
# @see Matchi::Change
# @see Matchi::Eq
# @see Matchi::Match
# @see Matchi::Predicate
# @see Matchi::RaiseException
# @see Matchi::Satisfy
module Matchi
end

require "matchi/be"
require "matchi/be_a_kind_of"
require "matchi/be_an_instance_of"
require "matchi/be_within"
require "matchi/change"
require "matchi/eq"
require "matchi/match"
require "matchi/predicate"
require "matchi/raise_exception"
require "matchi/satisfy"
