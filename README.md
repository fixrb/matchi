# Matchi

[![Build Status](https://travis-ci.org/fixrb/matchi.svg?branch=master)](https://travis-ci.org/fixrb/matchi)
[![Dependency Status](https://gemnasium.com/fixrb/matchi.svg)](https://gemnasium.com/fixrb/matchi)
[![Gem Version](http://img.shields.io/gem/v/matchi.svg)](https://rubygems.org/gems/matchi)
[![Inline docs](http://inch-ci.org/github/fixrb/matchi.svg?branch=master)](http://inch-ci.org/github/fixrb/matchi)
[![Documentation](http://img.shields.io/:yard-docs-38c800.svg)](http://rubydoc.info/gems/matchi/frames)

> Collection of expectation matchers for Ruby.

## Contact

* Home page: https://github.com/fixrb/matchi
* Bugs/issues: https://github.com/fixrb/matchi/issues
* Support: https://stackoverflow.com/questions/tagged/matchi

## Rubies

* [MRI](https://www.ruby-lang.org/)
* [Rubinius](http://rubini.us/)
* [JRuby](http://jruby.org/)

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

List all available matchers:

```ruby
Matchi.constants # => [:BeFalse, :BeNil, :BeTrue, :Eql, :Equal, :Match, :RaiseException]
```

### Built-in matchers

**Equivalence** matcher:

```ruby
eql = Matchi.fetch(:Eql, 'foo')
eql.matches? { 'foo' } # => true
```

**Identity** matcher:

```ruby
equal = Matchi.fetch(:Equal, :foo)
equal.matches? { :foo } # => true
```

**Regular expressions** matcher:

```ruby
match = Matchi.fetch(:Match, /^foo$/)
match.matches? { 'foo' } # => true
```

**Expecting errors** matcher:

```ruby
raise_exception = Matchi.fetch(:RaiseException, NameError)
raise_exception.matches? { Boom } # => true
```

**Truth** matcher:

```ruby
be_true = Matchi.fetch(:BeTrue)
be_true.matches? { true } # => true
```

**Untruth** matcher:

```ruby
be_false = Matchi.fetch(:BeFalse)
be_false.matches? { false } # => true
```

**Nil** matcher:

```ruby
be_nil = Matchi.fetch(:BeNil)
be_nil.matches? { nil } # => true
```

### Custom matchers

Custom matchers can easily be defined for expressing expectations.

**Be the answer** matcher:

```ruby
module Matchi
  class BeTheAnswer
    def matches?
      42.equal? yield
    end
  end
end

be_the_answer = Matchi.fetch(:BeTheAnswer)
be_the_answer.matches? { 42 } # => true
```

**Be prime** matcher:

```ruby
require 'prime'

module Matchi
  class BePrime
    def matches?
      Prime.prime? yield
    end
  end
end

be_prime = Matchi.fetch(:BePrime)
be_prime.matches? { 42 } # => false
```

**Start with** matcher:

```ruby
module Matchi
  class StartWith
    def initialize expected
      @expected = expected
    end

    def matches?
      !Regexp.new("^#{@expected}").match(yield).nil?
    end
  end
end

start_with = Matchi.fetch(:StartWith, 'foo')
start_with.matches? { 'foobar' } # => true
```

## Versioning

__Matchi__ follows [Semantic Versioning 2.0](http://semver.org/).

## Contributing

1. [Fork it](https://github.com/fixrb/matchi/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
