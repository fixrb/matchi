# Matchi

[![Build Status](https://travis-ci.org/fixrb/matchi.svg?branch=master)][travis]
[![Gem Version](https://badge.fury.io/rb/matchi.svg)][gem]
[![Inline docs](http://inch-ci.org/github/fixrb/matchi.svg?branch=master)][inchpages]
[![Documentation](http://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

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

__Matchi__ is cryptographically signed.

To be sure the gem you install hasn't been tampered with, add my public key
(if you haven't already) as a trusted certificate:

    $ gem cert --add <(curl -Ls https://raw.github.com/fixrb/matchi/master/certs/gem-fixrb-public_cert.pem)
    $ gem install matchi -P HighSecurity

The `HighSecurity` trust profile will verify all gems.  All of __Matchi__'s
dependencies are signed.

## Usage

### List all matchers

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

__Matchi__ follows [Semantic Versioning 2.0](http://semver.org/).

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
[inchpages]: http://inch-ci.org/github/fixrb/matchi/
[rubydoc]: http://rubydoc.info/gems/matchi/frames
