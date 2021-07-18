# Matchi

[![Version](https://img.shields.io/github/v/tag/fixrb/matchi?label=Version&logo=github)](https://github.com/fixrb/matchi/releases)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/fixrb/matchi/main)
[![CI](https://github.com/fixrb/matchi/workflows/CI/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Aci+branch%3Amain)
[![RuboCop](https://github.com/fixrb/matchi/workflows/RuboCop/badge.svg?branch=main)](https://github.com/fixrb/matchi/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/fixrb/matchi?label=License&logo=github)](https://github.com/fixrb/matchi/raw/main/LICENSE.md)

> Collection of expectation matchers for Ruby 🤹

![A rubyist juggling between colored balls representing expectation matchers](https://github.com/fixrb/matchi/raw/main/img/matchi.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "matchi"
```

And then execute:

```sh
bundle
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

### Built-in matchers

**Equivalence** matcher:

```ruby
eql = Matchi::Matcher::Eql.new("foo")
eql.matches? { "foo" } # => true
```

**Identity** matcher:

```ruby
equal = Matchi::Matcher::Equal.new(:foo)
equal.matches? { :foo } # => true
```

**Regular expressions** matcher:

```ruby
match = Matchi::Matcher::Match.new(/^foo$/)
match.matches? { "foo" } # => true
```

**Expecting errors** matcher:

```ruby
raise_exception = Matchi::Matcher::RaiseException.new(NameError)
raise_exception.matches? { Boom } # => true
```

**Truth** matcher:

```ruby
be_true = Matchi::Matcher::BeTrue.new
be_true.matches? { true } # => true
```

**Untruth** matcher:

```ruby
be_false = Matchi::Matcher::BeFalse.new
be_false.matches? { false } # => true
```

**Nil** matcher:

```ruby
be_nil = Matchi::Matcher::BeNil.new
be_nil.matches? { nil } # => true
```

**Type/class** matcher:

```ruby
be_an_instance_of = Matchi::Matcher::BeAnInstanceOf.new(:String)
be_an_instance_of.matches? { "foo" } # => true
```

### Custom matchers

Custom matchers can easily be defined for expressing expectations.
They can be any Ruby class that responds to `matches?` instance method with a block.

A **Be the answer** matcher:

```ruby
module Matchi
  module Matcher
    class BeTheAnswer < ::Matchi::Matcher::Base
      def matches?
        42.equal?(yield)
      end
    end
  end
end

be_the_answer = Matchi::Matcher::BeTheAnswer.new
be_the_answer.matches? { 42 } # => true
```

A **Be prime** matcher:

```ruby
require "prime"

module Matchi
  module Matcher
    class BePrime < ::Matchi::Matcher::Base
      def matches?
        Prime.prime?(yield)
      end
    end
  end
end

be_prime = Matchi::Matcher::BePrime.new
be_prime.matches? { 42 } # => false
```

A **Start with** matcher:

```ruby
module Matchi
  module Matcher
    class StartWith < ::Matchi::Matcher::Base
      def initialize(expected)
        super()
        @expected = expected
      end

      def matches?
        Regexp.new(/\A#{expected}/).match?(yield)
      end
    end
  end
end

start_with = Matchi::Matcher::StartWith.new("foo")
start_with.matches? { "foobar" } # => true
```

### Helper methods

For convenience, it is possible to instantiate a matcher with a method rather than with its class.
To do so, the `Helper` module can be included like this:

```ruby
require "matchi/helper"

class MatcherCollection
  include ::Matchi::Helper
end
```

The set of loaded matcher then becomes accessible via a dynamically generated instance method, like these:

```ruby
matcher = MatcherCollection.new
matcher.equal(42).matches? { 44 } # => false
matcher.be_an_instance_of(String).matches? { "안녕하세요" } # => true
```

## Contact

* Home page: https://github.com/fixrb/matchi
* Bugs/issues: https://github.com/fixrb/matchi/issues

## Versioning

__Matchi__ follows [Semantic Versioning 2.0](https://semver.org/).

## License

The [gem](https://rubygems.org/gems/matchi) is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

***

<p>
  This project is sponsored by:<br />
  <a href="https://sashite.com/"><img
    src="https://github.com/fixrb/matchi/raw/main/img/sashite.png"
    alt="Sashite" /></a>
</p>
