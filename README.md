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

A __Matchi__ matcher is an object that must respond to the `match?` method with a block as argument, and return a boolean.

To facilitate the integration of the matchers in other tools, __Matchi__ matchers may also respond to `to_s` method.

### Built-in matchers

Here is the collection of useful generic matchers.

**Equivalence** matcher:

```ruby
matcher = Matchi::Eq.new("foo")
matcher.match? { "foo" } # => true
```

**Identity** matcher:

```ruby
matcher = Matchi::Be.new(:foo)
matcher.match? { :foo } # => true
```

**Comparisons** matcher:

```ruby
matcher = Matchi::BeWithin.new(8).of(37)
matcher.match? { 42 } # => true
```

**Regular expressions** matcher:

```ruby
matcher = Matchi::Match.new(/^foo$/)
matcher.match? { "foo" } # => true
```

**Expecting errors** matcher:

```ruby
matcher = Matchi::RaiseException.new(:NameError)
matcher.match? { Boom } # => true
```

**Type/class** matcher:

```ruby
matcher = Matchi::BeAnInstanceOf.new(:String)
matcher.match? { "foo" } # => true
```

**Predicate** matcher:

```ruby
matcher = Matchi::Predicate.new(:be_empty)
matcher.match? { [] } # => true

matcher = Matchi::Predicate.new(:have_key, :foo)
matcher.match? { { foo: 42 } } # => true
```

**Change** matcher:

```ruby
object = []
matcher = Matchi::Change.new(object, :length).by(1)
matcher.match? { object << 1 } # => true

object = []
matcher = Matchi::Change.new(object, :length).by_at_least(1)
matcher.match? { object << 1 } # => true

object = []
matcher = Matchi::Change.new(object, :length).by_at_most(1)
matcher.match? { object << 1 } # => true

object = "foo"
matcher = Matchi::Change.new(object, :to_s).from("foo").to("FOO")
matcher.match? { object.upcase! } # => true

object = "foo"
matcher = Matchi::Change.new(object, :to_s).to("FOO")
matcher.match? { object.upcase! } # => true
```

**Satisfy** matcher:

```ruby
matcher = Matchi::Satisfy.new { |value| value == 42 }
matcher.match? { 42 } # => true
```

### Custom matchers

Custom matchers can easily be added to express more specific expectations.

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
