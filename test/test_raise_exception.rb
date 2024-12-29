# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "raise_exception")

#
# Base functionality
#

# Test with simple exceptions
matcher = Matchi::RaiseException.new(:StandardError)
raise unless matcher.match? { raise StandardError }
raise if matcher.match? { "no error" }

#
# Test class name validation
#

# Test with various valid class name formats
[
  "StandardError", # Basic
  "ERROR",           # All caps
  "MyCustomError",   # CamelCase
  "Error123",        # With numbers
  "Custom_Error"     # With underscore
].each do |name|
  Matchi::RaiseException.new(name)
rescue ArgumentError
  raise "Should accept valid class name: #{name}"
end

# Test with invalid class name formats
[
  "error",           # lowercase start
  "123Error",        # number start
  ""                 # empty string
].each do |name|
  Matchi::RaiseException.new(name)
  raise "Should reject invalid class name: #{name}"
rescue ArgumentError => e
  raise unless e.message == "expected must start with an uppercase letter (got: #{name})"
end

#
# Test inheritance behavior
#

class ParentError < StandardError; end
class ChildError < ParentError; end
class SiblingError < ParentError; end

# Test exact class matching
matcher = Matchi::RaiseException.new(ParentError)
raise unless matcher.match? { raise ParentError }  # ParentError matches ParentError

matcher = Matchi::RaiseException.new(ChildError)
raise unless matcher.match? { raise ChildError }   # ChildError matches ChildError

# Test that child classes match parent matchers
matcher = Matchi::RaiseException.new(ParentError)
raise unless matcher.match? { raise ChildError } # ChildError matches ParentError

# Test that parent classes don't match child matchers
matcher = Matchi::RaiseException.new(ChildError)
raise if matcher.match? { raise ParentError } # ParentError doesn't match ChildError

# Test that sibling classes don't match each other
matcher = Matchi::RaiseException.new(ChildError)
raise if matcher.match? { raise SiblingError } # SiblingError doesn't match ChildError

#
# Test with standard Ruby exceptions
#

[
  RuntimeError,
  NoMethodError,
  NameError,
  ArgumentError,
  TypeError,
  ZeroDivisionError
].each do |error_class|
  # Should match its own class
  matcher = Matchi::RaiseException.new(error_class)
  raise unless matcher.match? { raise error_class }

  # Should not match with generic StandardError
  raise if matcher.match? { raise StandardError }
end

#
# Test with nested modules/classes
#

module TestModule
  class ModuleError < StandardError; end

  module NestedModule
    class NestedError < StandardError; end
  end
end

# Test with single level nesting
matcher = Matchi::RaiseException.new("TestModule::ModuleError")
raise unless matcher.match? { raise TestModule::ModuleError }

# Test with multiple level nesting
matcher = Matchi::RaiseException.new("TestModule::NestedModule::NestedError")
raise unless matcher.match? { raise TestModule::NestedModule::NestedError }

#
# Test special cases
#

# Test with non existent class during initialization (should not raise)
Matchi::RaiseException.new(:NonExistentError)

# Test with non existent class during match (should raise NameError)
matcher = Matchi::RaiseException.new(:NonExistentError)
begin
  matcher.match? { "test" }
  raise "Should raise NameError for non-existent class"
rescue NameError
  # Expected
end

# Test with non-Exception class
matcher = Matchi::RaiseException.new(:String)
begin
  matcher.match? { "test" }
  raise "Should raise ArgumentError for non-Exception class"
rescue ArgumentError => e
  raise unless e.message == "expected exception class must inherit from Exception"
end

# Test without block
begin
  matcher = Matchi::RaiseException.new(:StandardError)
  matcher.match?
  raise "Should raise ArgumentError when no block given"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end

#
# Test string representations
#

matcher = Matchi::RaiseException.new(:CustomError)
raise unless matcher.to_s == "raise exception CustomError"

#
# Test exception messages
#

# Should match regardless of the error message
matcher = Matchi::RaiseException.new(StandardError)
raise unless matcher.match? { raise StandardError, "test message" }
raise unless matcher.match? { raise StandardError, "" }
raise unless matcher.match? { raise StandardError }
