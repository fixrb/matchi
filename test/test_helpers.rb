# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi")

# Test class that includes Matchi
class IncludeTest
  include Matchi

  def run_tests
    # Test eq/eql helper
    raise unless eq("foo").match? { "foo" }
    raise unless eql("foo").match? { "foo" }

    # Test be/equal helper
    obj = "foo"
    raise unless be(obj).match? { obj }
    raise unless equal(obj).match? { obj }

    # Test be_within helper
    raise unless be_within(1).of(41).match? { 42 }

    # Test match helper
    raise unless match(/^foo/).match? { "foobar" }

    # Test raise_exception helper
    raise unless raise_exception(NameError).match? { Boom }

    # Test be_true/be_false/be_nil helpers
    raise unless be_true.match? { true }
    raise unless be_false.match? { false }
    raise unless be_nil.match? { nil }

    # Test be_an_instance_of helper
    raise unless be_an_instance_of(String).match? { "foo" }

    # Test be_a_kind_of helper
    raise unless be_a_kind_of(Numeric).match? { 42 }

    # Test change helper
    array = []
    raise unless change(array, :length).by(1).match? { array << 1 }

    # Test satisfy helper
    raise unless satisfy { |value| value == 42 }.match? { 42 }

    # Test predicate matchers (be_* and have_*)
    raise unless be_empty.match? { [] }
    raise unless have_key(:foo).match? { { foo: 42 } }
  end
end

# Test class that extends Matchi
class ExtendTest
  extend Matchi

  def self.run_tests
    # Test eq/eql helper
    raise unless eq("foo").match? { "foo" }
    raise unless eql("foo").match? { "foo" }

    # Test be/equal helper
    obj = "foo"
    raise unless be(obj).match? { obj }
    raise unless equal(obj).match? { obj }

    # Test be_within helper
    raise unless be_within(1).of(41).match? { 42 }

    # Test match helper
    raise unless match(/^foo/).match? { "foobar" }

    # Test raise_exception helper
    raise unless raise_exception(NameError).match? { Boom }

    # Test be_true/be_false/be_nil helpers
    raise unless be_true.match? { true }
    raise unless be_false.match? { false }
    raise unless be_nil.match? { nil }

    # Test be_an_instance_of helper
    raise unless be_an_instance_of(String).match? { "foo" }

    # Test be_a_kind_of helper
    raise unless be_a_kind_of(Numeric).match? { 42 }

    # Test change helper
    array = []
    raise unless change(array, :length).by(1).match? { array << 1 }

    # Test satisfy helper
    raise unless satisfy { |value| value == 42 }.match? { 42 }

    # Test predicate matchers (be_* and have_*)
    raise unless be_empty.match? { [] }
    raise unless have_key(:foo).match? { { foo: 42 } }
  end
end

# Run all tests
IncludeTest.new.run_tests
ExtendTest.run_tests

# Additional edge cases and error conditions

# Test that method_missing works correctly for invalid matcher names
include_test = IncludeTest.new
begin
  include_test.not_a_matcher
  raise "Should raise NoMethodError for invalid matcher name"
rescue NoMethodError
  # Expected
end

# Test respond_to? behavior
raise unless include_test.respond_to?(:be_empty)
raise unless include_test.respond_to?(:have_key)
raise if include_test.respond_to?(:not_a_matcher)

# Test that extend works the same way
raise unless ExtendTest.respond_to?(:be_empty)
raise unless ExtendTest.respond_to?(:have_key)
raise if ExtendTest.respond_to?(:not_a_matcher)
