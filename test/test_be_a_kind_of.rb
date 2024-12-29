# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_a_kind_of")

# Test base class matching
matcher = Matchi::BeAKindOf.new(String)
raise unless matcher.match? { "test" }
raise if matcher.match? { 42 }

# Test string representations
raise unless matcher.to_s == "be a kind of String"
raise unless matcher.inspect == "Matchi::BeAKindOf(String)"

# Test with symbol class name
matcher = Matchi::BeAKindOf.new(:String)
raise unless matcher.match? { "test" }
raise if matcher.match? { 42 }

# Test class hierarchy
class GrandParent; end # rubocop:disable Lint/EmptyClass
class Parent < GrandParent; end
class Child < Parent; end

matcher = Matchi::BeAKindOf.new(Parent)
raise unless matcher.match? { Child.new }
raise unless matcher.match? { Parent.new }

matcher = Matchi::BeAKindOf.new(GrandParent)
raise unless matcher.match? { Child.new }
raise unless matcher.match? { Parent.new }
raise unless matcher.match? { GrandParent.new }

# Test interface/module inclusion
module Walkable
  def walk; end
end

class Walker
  include Walkable
end

matcher = Matchi::BeAKindOf.new(Walkable)
raise unless matcher.match? { Walker.new }
raise if matcher.match? { Object.new }

# Test with built-in class hierarchy
matcher = Matchi::BeAKindOf.new(Numeric)
raise unless matcher.match? { 42 }
raise unless matcher.match? { 42.0 }
raise if matcher.match? { "42" }

# Test with nil
matcher = Matchi::BeAKindOf.new(NilClass)
raise unless matcher.match? { nil }
raise if matcher.match? { "not nil" }

# Test with non existent class during initialisation
Matchi::BeAKindOf.new(:NonExistentClass) # Should not raise any error

# Test with non existent class during match?
matcher = Matchi::BeAKindOf.new(:NonExistentClass)
begin
  matcher.match? { "test" } # Now it should raise error
  raise
rescue NameError
  true
end

# Test absence of block for match?
begin
  matcher = Matchi::BeAKindOf.new(String)
  matcher.match?
  raise
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end

# Test invalid inputs
begin
  Matchi::BeAKindOf.new("")
  raise
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: )"
end

begin
  Matchi::BeAKindOf.new("lowercase")
  raise
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: lowercase)"
end

begin
  Matchi::BeAKindOf.new(42)
  raise
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: 42)"
end

begin
  Matchi::BeAKindOf.new(nil)
  raise
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: )"
end

# Test edge cases for constant names
begin
  Matchi::BeAKindOf.new("Abc_123")  # Valid
  Matchi::BeAKindOf.new("ABC")      # Valid
rescue ArgumentError
  raise "Should accept valid constant names"
end

begin
  Matchi::BeAKindOf.new("123Abc")
  raise
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: 123Abc)"
end

# Test nested modules/classes
module OuterModule
  class InnerClass; end # rubocop:disable Lint/EmptyClass
  module InnerModule; end
end

matcher = Matchi::BeAKindOf.new("OuterModule::InnerClass")
raise unless matcher.match? { OuterModule::InnerClass.new }

matcher = Matchi::BeAKindOf.new("OuterModule::InnerModule")
raise if matcher.match? { Object.new }
