# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "eq")

matcher = Matchi::Eq.new("foo")

raise unless matcher.match? { "foo" }
raise if matcher.match? { "bar" }
raise unless matcher.to_s == 'eq "foo"'

# eql? is strict on type.
raise if Matchi::Eq.new(1).match? { 1.0 }
raise unless Matchi::Eq.new([1, "a"]).match? { [1, "a"] }

# The actual value cannot lie: the expected value receives the call.
liar = Object.new
def liar.eql?(_other) = true
def liar.==(_other) = true
raise if Matchi::Eq.new("foo").match? { liar }

# Hash#eql? and Set#eql? hand the comparison to an operand of another class;
# the class check closes that door.
hash_liar = Object.new
def hash_liar.respond_to?(name, *) = name == :to_hash
def hash_liar.eql?(_other) = true
raise if Matchi::Eq.new({}).match? { hash_liar }
raise if Matchi::Eq.new({ a: 1 }).match? { hash_liar }

set_liar = Object.new
def set_liar.is_a?(_klass) = true
def set_liar.instance_variable_get(_name) = { 1 => true }
raise if Matchi::Eq.new(Set[1]).match? { set_liar }
raise unless Matchi::Eq.new({ a: 1 }).match? { { a: 1 } }
raise unless Matchi::Eq.new(Set[1]).match? { Set[1] }

# Nested values are compared with eql? too, and a liar of the very same class
# does not receive the call either.
raise if Matchi::Eq.new({ a: 1 }).match? { { a: 1.0 } }
raise if Matchi::Eq.new([1]).match? { [1.0] }

same_class_liar = {}
def same_class_liar.eql?(_other) = true
raise if Matchi::Eq.new({ a: 1 }).match? { same_class_liar }

# A subclass instance is not eql? to a core value, with or without the class check.
raise if Matchi::Eq.new("foo").match? { Class.new(String).new("foo") }
raise if Matchi::Eq.new(nil).match? { false }
raise unless Matchi::Eq.new(nil).match? { nil }

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
