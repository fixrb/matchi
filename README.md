# Matchi

[![Build Status](https://api.travis-ci.org/fixrb/matchi.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/fixrb/matchi/badges/gpa.svg)][codeclimate]
[![Gem Version](https://badge.fury.io/rb/matchi.svg)][gem]
[![Inline docs](https://inch-ci.org/github/fixrb/matchi.svg?branch=master)][inchpages]
[![Documentation](https://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> Collection of expectation matchers for Ruby.

## Contact

* Home page: https://github.com/fixrb/matchi
* Bugs/issues: https://github.com/fixrb/matchi/issues

## Rubies

* [MRI](https://www.ruby-lang.org/)
* [Rubinius](https://rubinius.com/)
* [JRuby](https://www.jruby.org/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'matchi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install matchi

## Usage

### Built-in matchers

**Equivalence** matcher:

```ruby
eql = Matchi::Matchers::Eql::Matcher.new('foo')
eql.matches? { 'foo' } # => true
```

**Identity** matcher:

```ruby
equal = Matchi::Matchers::Equal::Matcher.new(:foo)
equal.matches? { :foo } # => true
```

**Regular expressions** matcher:

```ruby
match = Matchi::Matchers::Match::Matcher.new(/^foo$/)
match.matches? { 'foo' } # => true
```

**Expecting errors** matcher:

```ruby
raise_exception = Matchi::Matchers::RaiseException::Matcher.new(NameError)
raise_exception.matches? { Boom } # => true
```

**Truth** matcher:

```ruby
be_true = Matchi::Matchers::BeTrue::Matcher.new
be_true.matches? { true } # => true
```

**Untruth** matcher:

```ruby
be_false = Matchi::Matchers::BeFalse::Matcher.new
be_false.matches? { false } # => true
```

**Nil** matcher:

```ruby
be_nil = Matchi::Matchers::BeNil::Matcher.new
be_nil.matches? { nil } # => true
```

### Custom matchers

Custom matchers can easily be defined for expressing expectations.  They can be any Ruby class that responds to `matches?`, `to_s` and `to_h` instance methods.

A **Be the answer** matcher:

```ruby
module Matchi
  module Matchers
    module BeTheAnswer
      class Matcher
        def matches?
          42.equal? yield
        end

        def to_s
          'be_the_answer'
        end

        def to_h
          { BeTheAnswer: [] }
        end
      end
    end
  end
end

be_the_answer = Matchi::Matchers::BeTheAnswer::Matcher.new
be_the_answer.matches? { 42 } # => true
```

A **Be prime** matcher:

```ruby
require 'prime'

module Matchi
  module Matchers
    module BePrime
      class Matcher
        def matches?
          Prime.prime? yield
        end

        def to_s
          'be_prime'
        end

        def to_h
          { BePrime: [] }
        end
      end
    end
  end
end

be_prime = Matchi::Matchers::BePrime::Matcher.new
be_prime.matches? { 42 } # => false
```

A **Start with** matcher:

```ruby
module Matchi
  module Matchers
    module StartWith
      class Matcher
        def initialize(expected)
          @expected = expected
        end

        def matches?
          !Regexp.new("^#{@expected}").match(yield).nil?
        end

        def to_s
          'start_with'
        end

        def to_h
          { StartWith: [@expected] }
        end
      end
    end
  end
end

start_with = Matchi::Matchers::StartWith::Matcher.new('foo')
start_with.matches? { 'foobar' } # => true
```

## Security

As a basic form of security __Matchi__ provides a set of SHA512 checksums for
every Gem release.  These checksums can be found in the `checksum/` directory.
Although these checksums do not prevent malicious users from tampering with a
built Gem they can be used for basic integrity verification purposes.

The checksum of a file can be checked using the `sha512sum` command.  For
example:

    $ sha512sum pkg/matchi-0.0.1.gem
    548d9f669ded4e622182791a5390aaceae0bf2e557b0864f05a842b0be2c65e10e1fb8499f49a3b9efd0e8eaeb691351b1c670d6316ce49965a99683b1071389  pkg/matchi-0.0.1.gem

## Versioning

__Matchi__ follows [Semantic Versioning 2.0](https://semver.org/).

## Contributing

1. [Fork it](https://github.com/fixrb/matchi/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See `LICENSE.md` file.

[gem]: https://rubygems.org/gems/matchi
[travis]: https://travis-ci.org/fixrb/matchi
[codeclimate]: https://codeclimate.com/github/fixrb/matchi
[inchpages]: https://inch-ci.org/github/fixrb/matchi
[rubydoc]: https://rubydoc.info/gems/matchi/frames

***

This project is sponsored by:

[![Sashite](https://pbs.twimg.com/profile_images/618485028322975744/PZ9qPuI__400x400.png)](https://sashite.com/)
