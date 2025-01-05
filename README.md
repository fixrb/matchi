# Matchi

[![Version](https://img.shields.io/github/v/tag/fixrb/matchi?label=Version&logo=github)](https://github.com/fixrb/matchi/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/fixrb/matchi/main)
[![License](https://img.shields.io/github/license/fixrb/matchi?label=License&logo=github)](https://github.com/fixrb/matchi/raw/main/LICENSE.md)

Matchi is a lightweight, framework-agnostic Ruby library that provides a comprehensive set of expectation matchers for elegant and secure testing. Its design focuses on simplicity, security, and extensibility.

![A Rubyist juggling between Matchi letters](https://github.com/fixrb/matchi/raw/main/img/matchi.png)

## Key Features

- **Framework Agnostic**: Easily integrate with any Ruby testing framework
- **Security-Focused Design**: Built with robust type checking for most matchers
- **Simple Integration**: Minimal setup required to get started
- **Extensible**: Create custom matchers with just a few lines of code
- **Comprehensive**: Rich set of built-in matchers for common testing scenarios
- **Well Documented**: Extensive documentation with clear examples and implementation details
- **Thread Safe**: Immutable matchers design ensures thread safety in concurrent environments

### Security Considerations for Predicate Matchers

While most Matchi matchers are designed to resist type spoofing, predicate matchers (`Matchi::Predicate`) rely on Ruby's dynamic method dispatch system and can be vulnerable to method overriding:

```ruby
# Example of predicate matcher vulnerability:
matcher = Matchi::Predicate.new(:be_empty)
array = []

# Method overriding can defeat the matcher
def array.empty?
  false
end

matcher.match? { array } # => false (Even though array is empty!)
```

This limitation is inherent to Ruby's dynamic nature when working with predicate methods. If your tests require strict security guarantees, consider using direct state verification matchers instead of predicate matchers.

## What is a Matchi Matcher?

A Matchi matcher is a simple Ruby object that follows a specific contract:

1. **Core Interface**: Every matcher must implement a `match?` method that:
   - Accepts a block as its only parameter
   - Executes that block to get the actual value
   - Returns a boolean indicating if the actual value matches the expected criteria

2. **Optional Description**: Matchers can implement a `to_s` method that returns a human-readable description of the match criteria

Here's the simplest possible matcher:

```ruby
module Matchi
  class SimpleEqual
    def initialize(expected)
      @expected = expected
    end

    def match?
      raise ArgumentError, "a block must be provided" unless block_given?

      @expected == yield
    end

    def to_s
      "equal #{@expected.inspect}"
    end
  end
end

# Usage:
matcher = Matchi::SimpleEqual.new(42)
matcher.match? { 42 }     # => true
matcher.match? { "42" }   # => false
matcher.to_s              # => "equal 42"
```

This design provides several benefits:
- **Lazy Evaluation**: The actual value is only computed when needed via the block
- **Encapsulation**: Each matcher is a self-contained object with clear responsibilities
- **Composability**: Matchers can be easily combined and reused
- **Testability**: The contract is simple and easy to verify

## Installation

Add to your Gemfile:

```ruby
gem "matchi"
```

Or install directly:

```ruby
gem install matchi
```

## Quick Start

```ruby
require "matchi"

# Basic equality matching
Matchi::Eq.new("hello").match? { "hello" } # => true

# Type checking
Matchi::BeAKindOf.new(Numeric).match? { 42 }   # => true
Matchi::BeAKindOf.new(String).match? { 42 }    # => false

# State change verification
array = []
Matchi::Change.new(array, :length).by(2).match? { array.push(1, 2) } # => true
```

## Core Matchers

### Value Comparison

```ruby
# Exact equality (eql?)
Matchi::Eq.new("test").match? { "test" } # => true
Matchi::Eq.new([1, 2, 3]).match? { [1, 2, 3] } # => true

# Object identity (equal?)
symbol = :test
Matchi::Be.new(symbol).match? { symbol } # => true
string = "test"
Matchi::Be.new(string).match? { string.dup } # => false
```

### Type Checking

```ruby
# Inheritance-aware type checking
Matchi::BeAKindOf.new(Numeric).match? { 42.0 } # => true
Matchi::BeAKindOf.new(Integer).match? { 42.0 } # => false

# Exact type matching
Matchi::BeAnInstanceOf.new(Float).match? { 42.0 } # => true
Matchi::BeAnInstanceOf.new(Numeric).match? { 42.0 } # => false

# Using class names as strings
Matchi::BeAKindOf.new("Numeric").match? { 42.0 } # => true
Matchi::BeAnInstanceOf.new("Float").match? { 42.0 } # => true
```

### State Changes

```ruby
# Verify exact changes
counter = 0
Matchi::Change.new(counter, :to_i).by(5).match? { counter += 5 } # => true

# Verify minimum changes
Matchi::Change.new(counter, :to_i).by_at_least(2).match? { counter += 3 } # => true

# Verify maximum changes
Matchi::Change.new(counter, :to_i).by_at_most(5).match? { counter += 3 } # => true

# Track value transitions
string = "hello"
Matchi::Change.new(string, :to_s).from("hello").to("HELLO").match? { string.upcase! } # => true

# Simple change detection
array = []
Matchi::Change.new(array, :length).match? { array << 1 } # => true

# Check final state only
counter = 0
Matchi::Change.new(counter, :to_i).to(5).match? { counter = 5 } # => true
```

### Pattern Matching

```ruby
# Regular expressions
Matchi::Match.new(/^test/).match? { "test_string" } # => true
Matchi::Match.new(/^\d{3}-\d{2}$/).match? { "123-45" } # => true

# Custom predicates with Satisfy
Matchi::Satisfy.new { |x| x.positive? && x < 10 }.match? { 5 } # => true
Matchi::Satisfy.new { |arr| arr.all?(&:even?) }.match? { [2, 4, 6] } # => true

# Built-in predicates
Matchi::Predicate.new(:be_empty).match? { [] } # => true
Matchi::Predicate.new(:have_key, :name).match? { { name: "Alice" } } # => true
```

### Exception Handling

```ruby
# Verify raised exceptions
Matchi::RaiseException.new(ArgumentError).match? { raise ArgumentError } # => true

# Works with inheritance
Matchi::RaiseException.new(StandardError).match? { raise ArgumentError } # => true

# Using exception class names
Matchi::RaiseException.new("ArgumentError").match? { raise ArgumentError } # => true
```

### Numeric Comparisons

```ruby
# Delta comparisons
Matchi::BeWithin.new(0.5).of(3.0).match? { 3.2 } # => true
Matchi::BeWithin.new(2).of(10).match? { 9 } # => true
```

## Creating Custom Matchers

Creating custom matchers is straightforward:

```ruby
module Matchi
  class BePositive
    def match?
      yield.positive?
    end

    def to_s
      "be positive"
    end
  end
end

matcher = Matchi::BePositive.new
matcher.match? { 42 }  # => true
matcher.match? { -1 }  # => false
```

## Security Best Practices

### Proper Value Comparison Order

One of the most critical aspects when implementing matchers is the order of comparison between expected and actual values. Always compare values in this order:

```ruby
# GOOD: Expected value controls the comparison
expected_value.eql?(actual_value)
# BAD: Actual value controls the comparison
actual_value.eql?(expected_value)
```

#### Why This Matters

The order is crucial because the object receiving the comparison method controls how the comparison is performed. When testing, the actual value might come from untrusted or malicious code that could override comparison methods:

```ruby
# Example of how comparison can be compromised
class MaliciousString
  def eql?(other)
    true  # Always returns true regardless of actual equality
  end

  def ==(other)
    true  # Always returns true regardless of actual equality
  end
end

actual = MaliciousString.new
expected = "expected string"
actual.eql?(expected)      # => true (incorrect result!)
expected.eql?(actual)      # => false (correct result)
```

This is why Matchi's built-in matchers are implemented with this security consideration in mind. For example, the `Eq` matcher:

```ruby
# Implementation in Matchi::Eq
def match?
  @expected.eql?(yield) # Expected value controls the comparison
end
```

## Extensions

### matchi-fix

The [matchi-fix gem](https://rubygems.org/gems/matchi-fix) extends Matchi with support for testing against [Fix](https://github.com/fixrb/fix) specifications. It provides a seamless integration between Matchi's matcher interface and Fix's powerful specification system.

```ruby
# Add to your Gemfile
gem "matchi-fix"
```

This extension adds a `Fix` matcher that allows you to verify implementation conformance to Fix test specifications across different testing frameworks like Minitest and RSpec.

## Versioning

Matchi follows [Semantic Versioning 2.0](https://semver.org/).

## License

The [gem](https://rubygems.org/gems/matchi) is available as open source under the terms of the [MIT License](https://github.com/fixrb/matchi/raw/main/LICENSE.md).

## Sponsors

This project is sponsored by [Sashité](https://sashite.com/)
