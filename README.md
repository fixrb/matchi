# Matchi

[![Version](https://img.shields.io/github/v/tag/fixrb/matchi?label=Version&logo=github)](https://github.com/fixrb/matchi/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/fixrb/matchi/main)
[![Ruby](https://github.com/fixrb/matchi/workflows/Ruby/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Aruby+branch%3Amain)
[![RuboCop](https://github.com/fixrb/matchi/workflows/RuboCop/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/fixrb/matchi?label=License&logo=github)](https://github.com/fixrb/matchi/raw/main/LICENSE.md)

This library provides a comprehensive set of matchers for testing different aspects of your code.
Each matcher is designed to handle specific verification needs while maintaining a clear and expressive syntax.

![A Rubyist juggling between Matchi letters](https://github.com/fixrb/matchi/raw/main/img/matchi.png)

## Project goals

* Adding matchers should be as simple as possible.
* Being framework agnostic and easy to integrate.
* Avoid false positives/negatives due to malicious actual values.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "matchi"
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install matchi
```

## Overview

__Matchi__ provides a collection of damn simple expectation matchers.

## Usage

To make __Matchi__ available:

```ruby
require "matchi"
```

All examples here assume that this has been done.

### Anatomy of a matcher

A **Matchi** matcher is a simple Ruby object that follows these requirements:

1. It must implement a `match?` method that:
   - Accepts a block as its only parameter
   - Executes that block to get the actual value
   - Returns a boolean indicating if the actual value matches the expected criteria

2. Optionally, it may implement:
   - `to_s`: Returns a human-readable description of the match criteria

### Built-in matchers

Here is the collection of generic matchers.

#### Basic Comparison Matchers

##### `Be`
Checks for object identity using Ruby's `equal?` method.
```ruby
Matchi::Be.new(:foo).match? { :foo } # => true (same object)
Matchi::Be.new("test").match? { "test" } # => false (different objects)
```

##### `Eq`
Verifies object equivalence using Ruby's `eql?` method.
```ruby
Matchi::Eq.new("foo").match? { "foo" } # => true (equivalent content)
Matchi::Eq.new([1, 2]).match? { [1, 2] } # => true (equivalent arrays)
```

#### Type and Class Matchers

##### `BeAnInstanceOf`
Verifies exact class matching (no inheritance).
```ruby
Matchi::BeAnInstanceOf.new(String).match? { "test" }  # => true
Matchi::BeAnInstanceOf.new(Integer).match? { 42 }     # => true
Matchi::BeAnInstanceOf.new(Numeric).match? { 42 }     # => false (Integer, not Numeric)
```

##### `BeAKindOf`
Verifies class inheritance and module inclusion.
```ruby
Matchi::BeAKindOf.new(Numeric).match? { 42 }    # => true (Integer inherits from Numeric)
Matchi::BeAKindOf.new(Numeric).match? { 42.0 }  # => true (Float inherits from Numeric)
```

#### Pattern Matchers

##### `Match`
Tests string patterns against regular expressions.
```ruby
Matchi::Match.new(/^foo/).match? { "foobar" }  # => true
Matchi::Match.new(/\d+/).match? { "abc123" }   # => true
Matchi::Match.new(/^foo/).match? { "barfoo" }  # => false
```

##### `Satisfy`
Provides custom matching through a block.
```ruby
Matchi::Satisfy.new { |x| x.positive? && x < 10 }.match? { 5 } # => true
Matchi::Satisfy.new { |x| x.start_with?("test") }.match? { "test_file" } # => true
```

#### State Change Matchers

##### `Change`
Verifies state changes in objects with multiple variation methods:

###### Basic Change
```ruby
array = []
Matchi::Change.new(array, :length).by(2).match? { array.push(1, 2) } # => true
```

###### Minimum Change
```ruby
counter = 0
Matchi::Change.new(counter, :to_i).by_at_least(2).match? { counter += 3 } # => true
```

###### Maximum Change
```ruby
value = 10
Matchi::Change.new(value, :to_i).by_at_most(5).match? { value += 3 } # => true
```

###### From-To Change
```ruby
string = "hello"
Matchi::Change.new(string, :upcase).from("hello").to("HELLO").match? { string.upcase! } # => true
```

###### To-Only Change
```ruby
number = 1
Matchi::Change.new(number, :to_i).to(5).match? { number = 5 } # => true
```

#### Numeric Matchers

##### `BeWithin`
Checks if a number is within a specified range of an expected value.
```ruby
Matchi::BeWithin.new(0.5).of(3.0).match? { 3.2 }  # => true
Matchi::BeWithin.new(5).of(100).match? { 98 }     # => true
```

#### Behavior Matchers

##### `RaiseException`
Verifies that code raises specific exceptions.
```ruby
Matchi::RaiseException.new(ArgumentError).match? { raise ArgumentError } # => true
Matchi::RaiseException.new(NameError).match? { undefined_variable } # => true
```

##### `Predicate`
Creates matchers for methods ending in `?`.

###### Using `be_` prefix
```ruby
Matchi::Predicate.new(:be_empty).match? { [] }  # => true (calls empty?)
Matchi::Predicate.new(:be_nil).match? { nil }   # => true (calls nil?)
```

###### Using `have_` prefix
```ruby
Matchi::Predicate.new(:have_key, :foo).match? { { foo: 42 } } # => true (calls has_key?)
```

### Custom matchers

Custom matchers could easily be added to `Matchi` module to express more specific expectations.

A **Be the answer** matcher:

```ruby
module Matchi
  class BeTheAnswer
    def match?
      expected.equal?(yield)
    end

    private

    def expected
      42
    end
  end
end

matcher = Matchi::BeTheAnswer.new
matcher.match? { 42 } # => true
```

A **Be prime** matcher:

```ruby
require "prime"

module Matchi
  class BePrime
    def match?
      Prime.prime?(yield)
    end
  end
end

matcher = Matchi::BePrime.new

matcher.match? { 42 } # => false
```

A **Start with** matcher:

```ruby
module Matchi
  class StartWith
    def initialize(expected)
      @expected = expected
    end

    def match?
      /\A#{@expected}/.match?(yield)
    end
  end
end

matcher = Matchi::StartWith.new("foo")
matcher.match? { "foobar" } # => true
```

## Best Practices

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

## Contact

* Home page: https://github.com/fixrb/matchi
* Bugs/issues: https://github.com/fixrb/matchi/issues

## Versioning

__Matchi__ follows [Semantic Versioning 2.0](https://semver.org/).

## License

The [gem](https://rubygems.org/gems/matchi) is available as open source under the terms of the [MIT License](https://github.com/fixrb/matchi/raw/main/LICENSE.md).

## Sponsors

This project is sponsored by [Sashité](https://sashite.com/)
