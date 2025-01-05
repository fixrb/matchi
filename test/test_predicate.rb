# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "predicate")

# Test unknown prefix error in method_name
class TestPredicate < Matchi::Predicate
  def valid_name?
    true # Bypass the initial validation
  end
end

begin
  matcher = TestPredicate.new("invalid_prefix_test")
  matcher.match? { "test" } # Ceci va maintenant atteindre method_name
  raise "Should raise error for unknown prefix"
rescue ArgumentError => e
  raise unless e.message == "unknown prefix in predicate name: invalid_prefix_test"
end

# Test invalid predicate prefixes
[
  "invalid_prefix_test",
  "do_something",
  "has_value", # 'has_' instead of 'have_'
  "being_empty", # 'being_' instead of 'be_'
  "is_valid",
  "check_value",
  "test_something"
].each do |invalid_name|
  Matchi::Predicate.new(invalid_name)
  raise "Should not accept invalid predicate name: #{invalid_name}"
rescue ArgumentError => e
  raise unless e.message == "invalid predicate name format"
end

# Verify that correct prefixes still work
%w[be_empty have_key].each do |valid_name|
  Matchi::Predicate.new(valid_name)
rescue ArgumentError
  raise "Should accept valid predicate name: #{valid_name}"
end

# Test TypeError when predicate returns non-boolean
class NonBooleanPredicate
  def empty?
    "not a boolean"
  end
end

begin
  matcher = Matchi::Predicate.new(:be_empty)
  matcher.match? { NonBooleanPredicate.new }
  raise "Expected TypeError for non-boolean predicate result"
rescue TypeError => e
  raise unless e.message == "Boolean expected, but String instance returned."
end

# Ensure other non-boolean types also raise TypeError
class NumericPredicate
  def empty?
    42
  end
end

begin
  matcher = Matchi::Predicate.new(:be_empty)
  matcher.match? { NumericPredicate.new }
  raise "Expected TypeError for numeric predicate result"
rescue TypeError => e
  raise unless e.message == "Boolean expected, but Integer instance returned."
end

# Verify that nil also raises TypeError
class NilPredicate
  def empty?
    nil # rubocop:disable Style/ReturnNilInPredicateMethodDefinition
  end
end

begin
  matcher = Matchi::Predicate.new(:be_empty)
  matcher.match? { NilPredicate.new }
  raise "Expected TypeError for nil predicate result"
rescue TypeError => e
  raise unless e.message == "Boolean expected, but NilClass instance returned."
end

matcher = Matchi::Predicate.new("be_empty")

# It is expected to be true
raise unless matcher.match? { [] }

# It is expected to be false
raise if matcher.match? { [4, 9] }

# It returns this string
raise unless matcher.to_s == "be empty"

matcher = Matchi::Predicate.new("have_key", :foo)

# It is expected to be true
raise unless matcher.match? { { foo: 42 } }

# It is expected to be false
raise if matcher.match? { { bar: 4 } }

# It returns this string
raise unless matcher.to_s == "have key :foo"

matcher = Matchi::Predicate.new(:be_swimmer, foo: "bar")

class Duck
  def swimmer?(**_options)
    true
  end
end

# It is expected to be true
raise unless matcher.match? { Duck.new }

class Rhinoceros
  def swimmer?(**_options)
    false
  end
end

# It is expected to be false
raise if matcher.match? { Rhinoceros.new }

# It returns this string

raise unless matcher.to_s == 'be swimmer foo: "bar"'
