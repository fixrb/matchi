# Matchi

[![Version](https://img.shields.io/github/v/tag/fixrb/matchi?label=Version&logo=github)](https://github.com/fixrb/matchi/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/fixrb/matchi/main)
[![Ruby](https://github.com/fixrb/matchi/workflows/Ruby/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Aruby+branch%3Amain)
[![RuboCop](https://github.com/fixrb/matchi/workflows/RuboCop/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/fixrb/matchi?label=License&logo=github)](https://github.com/fixrb/matchi/raw/main/LICENSE.md)

> Collection of expectation matchers for Rubyists 🤹

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

A __Matchi__ matcher is an object that must respond to the `matches?` method with a block as argument, and return a boolean.

To facilitate the integration of the matchers in other tools, __Matchi__ matchers may expose expected values via the `expected` method.

### Built-in matchers

Here is the collection of useful generic matchers.

**Equivalence** matcher:

```ruby
matcher = Matchi::Eq.new("foo")

matcher.expected           # => "foo"
matcher.matches? { "foo" } # => true
```

**Identity** matcher:

```ruby
matcher = Matchi::Be.new(:foo)

matcher.expected          # => :foo
matcher.matches? { :foo } # => true
```

**Comparisons** matcher:

```ruby
matcher = Matchi::BeWithin.new(8).of(37)

matcher.expected        # => 37
matcher.matches? { 42 } # => true
```

**Regular expressions** matcher:

```ruby
matcher = Matchi::Match.new(/^foo$/)

matcher.expected           # => /^foo$/
matcher.matches? { "foo" } # => true
```

**Expecting errors** matcher:

```ruby
matcher = Matchi::RaiseException.new(:NameError)

matcher.expected          # => "NameError"
matcher.matches? { Boom } # => true
```

**Type/class** matcher:

```ruby
matcher = Matchi::BeAnInstanceOf.new(:String)

matcher.expected           # => "String"
matcher.matches? { "foo" } # => true
```

**Predicate** matcher:

```ruby
matcher = Matchi::Predicate.new(:be_empty)

matcher.expected        # => [:empty?, [], {}, nil]
matcher.matches? { [] } # => true

matcher = Matchi::Predicate.new(:have_key, :foo)

matcher.expected                 # => [:has_key?, [:foo], {}, nil]
matcher.matches? { { foo: 42 } } # => true
```

**Change** matcher:

```ruby
object = []
matcher = Matchi::Change.new(object, :length).by(1)

matcher.expected                 # => 1
matcher.matches? { object << 1 } # => true

object = []
matcher = Matchi::Change.new(object, :length).by_at_least(1)

matcher.expected                 # => 1
matcher.matches? { object << 1 } # => true

object = []
matcher = Matchi::Change.new(object, :length).by_at_most(1)

matcher.expected                 # => 1
matcher.matches? { object << 1 } # => true

object = "foo"
matcher = Matchi::Change.new(object, :to_s).from("foo").to("FOO")

matcher.expected                    # => "FOO"
matcher.matches? { object.upcase! } # => true

object = "foo"
matcher = Matchi::Change.new(object, :to_s).to("FOO")

matcher.expected                    # => "FOO"
matcher.matches? { object.upcase! } # => true
```

**Satisfy** matcher:

```ruby
matcher = Matchi::Satisfy.new { |value| value == 42 }

matcher.expected        # => #<Proc:0x00007fbaafc65540>
matcher.matches? { 42 } # => true
```

### Custom matchers

Custom matchers can easily be added to express more specific expectations.

A **Be the answer** matcher:

```ruby
module Matchi
  class BeTheAnswer
    def expected
      42
    end

    def matches?
      expected.equal?(yield)
    end
  end
end

matcher = Matchi::BeTheAnswer.new

matcher.expected        # => 42
matcher.matches? { 42 } # => true
```

A **Be prime** matcher:

```ruby
require "prime"

module Matchi
  class BePrime
    def matches?
      Prime.prime?(yield)
    end
  end
end

matcher = Matchi::BePrime.new

matcher.matches? { 42 } # => false
```

A **Start with** matcher:

```ruby
module Matchi
  class StartWith
    attr_reader :expected

    def initialize(expected)
      @expected = expected
    end

    def matches?
      /\A#{expected}/.match?(yield)
    end
  end
end

matcher = Matchi::StartWith.new("foo")

matcher.expected              # => "foo"
matcher.matches? { "foobar" } # => true
```

## Contact

* Home page: https://github.com/fixrb/matchi
* Bugs/issues: https://github.com/fixrb/matchi/issues

## Versioning

__Matchi__ follows [Semantic Versioning 2.0](https://semver.org/).

## License

The [gem](https://rubygems.org/gems/matchi) is available as open source under the terms of the [MIT License](https://github.com/fixrb/matchi/raw/main/LICENSE.md).

***

<p>
  This project is sponsored by:<br />
  <a href="https://sashite.com/"><img
    src="https://github.com/fixrb/matchi/raw/main/img/sashite.png"
    alt="Sashité" /></a>
</p>
