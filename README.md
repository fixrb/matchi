# Matchi

[![Build Status](https://api.travis-ci.org/fixrb/matchi.svg?branch=main)][travis]
[![Code Climate](https://codeclimate.com/github/fixrb/matchi/badges/gpa.svg)][codeclimate]
[![Gem Version](https://badge.fury.io/rb/matchi.svg)][gem]
[![Documentation](https://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> Collection of expectation matchers for Ruby 🤹

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

## Usage

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
be_an_instance_of = Matchi::Matcher::BeAnInstanceOf.new(String)
be_an_instance_of.matches? { "foo" } # => true
```

### Custom matchers

Custom matchers can easily be defined for expressing expectations.  They can be any Ruby class that responds to `matches?`, `to_s` and `to_h` instance methods.

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

[gem]: https://rubygems.org/gems/matchi
[travis]: https://travis-ci.org/fixrb/matchi
[codeclimate]: https://codeclimate.com/github/fixrb/matchi
[rubydoc]: https://rubydoc.info/gems/matchi/frames
