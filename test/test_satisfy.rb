# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "satisfy")

matcher = Matchi::Satisfy.new { |value| value > 41 }

raise unless matcher.match? { 42 }
raise if matcher.match? { 41 }
raise unless matcher.to_s == "satisfy &block"

# The predicate must answer true or false, not a truthy value.
begin
  Matchi::Satisfy.new { |value| value =~ /\d/ }.match? { "42" }
  raise "expected TypeError"
rescue TypeError
  nil
end

begin
  Matchi::Satisfy.new { |_value| nil }.match? { 42 }
  raise "expected TypeError"
rescue TypeError => e
  raise unless e.message == "the block must return true or false (got a NilClass)"
end
bomb = Object.new
def bomb.inspect = raise("inspect bomb")
begin
  Matchi::Satisfy.new { |_value| bomb }.match? { 42 }
  raise "expected TypeError"
rescue TypeError
  nil
end

# A method reference and a lambda work; a lambda must accept one argument.
raise unless Matchi::Satisfy.new(&:even?).match? { 42 }
raise unless Matchi::Satisfy.new(&->(value) { value > 41 }).match? { 42 }

begin
  Matchi::Satisfy.new(&-> { true }).match? { 42 }
  raise "expected ArgumentError"
rescue ArgumentError
  nil
end

# A predicate block is required.
begin
  Matchi::Satisfy.new
  raise "expected ArgumentError"
rescue ArgumentError
  nil
end

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
