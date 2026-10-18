# frozen_string_literal: true

# Framework-agnostic matchers for Ruby.
#
# A matcher is any object that responds to `match?` with a block and to
# `to_s`. The block is evaluated once and yields the actual value, or, for
# `Change` and `RaiseException`, produces the effect to observe; the matcher
# returns `true` or `false`. The expected value controls the comparison
# wherever a comparison takes place, so a hostile actual value cannot forge
# a match; `Predicate` and the `Change` refinements by delta, which use
# values produced by the object under test, depend on its honesty.
#
# @example
#   Matchi::Eq.new(42).match? { 42 } # => true
module Matchi
end

require_relative "matchi/be"
require_relative "matchi/be_a_kind_of"
require_relative "matchi/be_an_instance_of"
require_relative "matchi/be_within"
require_relative "matchi/change"
require_relative "matchi/eq"
require_relative "matchi/match"
require_relative "matchi/predicate"
require_relative "matchi/raise_exception"
require_relative "matchi/satisfy"
