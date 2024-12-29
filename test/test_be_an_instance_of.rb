# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_an_instance_of")

#
# Test constant resolution with namespace conflicts
#

# Create a dummy class in the global namespace
class CustomClass; end # rubocop:disable Lint/EmptyClass

# Create a different class with the same name in the Matchi::BeAnInstanceOf namespace
class Matchi::BeAnInstanceOf::CustomClass; end # rubocop:disable Lint/EmptyClass, Style/ClassAndModuleChildren

# The matcher should use the global class, not the one in its own namespace
matcher = Matchi::BeAnInstanceOf.new(:CustomClass)
raise unless matcher.match? { CustomClass.new }
raise if matcher.match? { Matchi::BeAnInstanceOf::CustomClass.new }

# Test with nested namespaces too
module OuterModule
  class CustomClass; end # rubocop:disable Lint/EmptyClass
end

matcher = Matchi::BeAnInstanceOf.new("OuterModule::CustomClass")
raise unless matcher.match? { OuterModule::CustomClass.new }
raise if matcher.match? { CustomClass.new }

#
# Test base class matching
#

# Test exact class matching
matcher = Matchi::BeAnInstanceOf.new(String)
raise unless matcher.match? { "test" }
raise if matcher.match? { 42 }

# Test string representations
raise unless matcher.to_s == "be an instance of String"

# Test with symbol class name
matcher = Matchi::BeAnInstanceOf.new(:String)
raise unless matcher.match? { "test" }
raise if matcher.match? { 42 }

#
# Test class hierarchy behavior
#

class GrandParent; end # rubocop:disable Lint/EmptyClass
class Parent < GrandParent; end
class Child < Parent; end

matcher = Matchi::BeAnInstanceOf.new(Parent)
raise if matcher.match? { Child.new } # Child should not match Parent
raise unless matcher.match? { Parent.new }  # Parent should match Parent
raise if matcher.match? { GrandParent.new } # GrandParent should not match Parent

matcher = Matchi::BeAnInstanceOf.new(GrandParent)
raise if matcher.match? { Child.new }            # Child should not match GrandParent
raise if matcher.match? { Parent.new }           # Parent should not match GrandParent
raise unless matcher.match? { GrandParent.new }  # GrandParent should match GrandParent

#
# Test interface/module inclusion
#

module Walkable
  def walk; end
end

class Walker
  include Walkable
end

matcher = Matchi::BeAnInstanceOf.new(Walker)
raise unless matcher.match? { Walker.new }    # Should match its own class
raise if matcher.match? { Object.new }        # Should not match unrelated class
raise if matcher.match? { Walkable }          # Should not match the module itself

#
# Test with built-in class hierarchy
#

matcher = Matchi::BeAnInstanceOf.new(Integer)
raise unless matcher.match? { 42 }      # Integer should match Integer
raise if matcher.match? { 42.0 }        # Float should not match Integer
raise if matcher.match? { "42" }        # String should not match Integer

matcher = Matchi::BeAnInstanceOf.new(Float)
raise if matcher.match? { 42 }          # Integer should not match Float
raise unless matcher.match? { 42.0 }    # Float should match Float
raise if matcher.match? { "42.0" }      # String should not match Float

#
# Test with nil
#

matcher = Matchi::BeAnInstanceOf.new(NilClass)
raise unless matcher.match? { nil }         # nil should match NilClass
raise if matcher.match? { "not nil" }       # String should not match NilClass

#
# Test with non existent class
#

# Test during initialization (should not raise)
Matchi::BeAnInstanceOf.new(:NonExistentClass)

# Test during match? (should raise NameError)
matcher = Matchi::BeAnInstanceOf.new(:NonExistentClass)
begin
  matcher.match? { "test" }
  raise
rescue NameError
  true
end

#
# Test absence of block for match?
#

begin
  matcher = Matchi::BeAnInstanceOf.new(String)
  matcher.match?
  raise
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end

#
# Test invalid inputs
#

[
  "",                  # Empty string
  "lowercase",         # Lowercase start
  "123UpperCase",      # Number start
  42,                  # Number
  nil                  # Nil
].each do |invalid_input|
  Matchi::BeAnInstanceOf.new(invalid_input)
  raise "Should reject invalid input: #{invalid_input.inspect}"
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: #{String(invalid_input)})"
end

#
# Test valid constant names
#

[
  "String",           # Simple class name
  "ABC",              # All uppercase
  "Abc_123",          # Mixed with underscore and numbers
  "TestClass"         # CamelCase
].each do |valid_input|
  Matchi::BeAnInstanceOf.new(valid_input)
rescue ArgumentError
  raise "Should accept valid constant name: #{valid_input}"
end

#
# Test nested modules/classes
#

module OuterModule
  class InnerClass; end # rubocop:disable Lint/EmptyClass

  module InnerModule
    class NestedClass; end # rubocop:disable Lint/EmptyClass
  end
end

matcher = Matchi::BeAnInstanceOf.new("OuterModule::InnerClass")
raise unless matcher.match? { OuterModule::InnerClass.new }
raise if matcher.match? { Object.new }

matcher = Matchi::BeAnInstanceOf.new("OuterModule::InnerModule::NestedClass")
raise unless matcher.match? { OuterModule::InnerModule::NestedClass.new }
raise if matcher.match? { OuterModule::InnerClass.new }
