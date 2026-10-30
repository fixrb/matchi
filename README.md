# Matchi

[![Version](https://img.shields.io/github/v/tag/fixrb/matchi?label=Version&logo=github)](https://github.com/fixrb/matchi/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/fixrb/matchi/main)
[![License](https://img.shields.io/github/license/fixrb/matchi?label=License&logo=github)](https://github.com/fixrb/matchi/raw/main/LICENSE.md)

Framework-agnostic matchers for Ruby. Small, explicit, and written so that the object under test cannot forge a match.

![A pixel-art jester juggling the letters of Matchi](https://github.com/fixrb/matchi/raw/main/img/matchi.png)

## Installation

```ruby
# Gemfile
gem "matchi"
```

Matchi requires Ruby 3.3 or later and has no runtime dependency.

## Usage

A matcher is built with its expected value, then asked whether an actual value matches. The block yields the actual value once; `match?` answers `true` or `false`.

```ruby
require "matchi"

matcher = Matchi::Eq.new(42)
matcher.match? { 42 } # => true
matcher.match? { 41 } # => false
matcher.to_s          # => "eq 42"
```

Every `to_s` completes the sentence "expected ACTUAL to …", which is all a test framework needs:

```ruby
# Minitest
def assert_matches(matcher, actual)
  assert matcher.match? { actual }, "expected #{actual.inspect} to #{matcher}"
end

def refute_matches(matcher, actual)
  refute matcher.match? { actual }, "expected #{actual.inspect} not to #{matcher}"
end

assert_matches Matchi::BeAKindOf.new(Numeric), 42
refute_matches Matchi::Match.new(/^foo/), "bar"
```

Negation is the framework's job: Matchi has no `not_to`, it answers a boolean.

## Matchers

```ruby
require "matchi"

# Identity (equal?) and equivalence (eql?)
Matchi::Be.new(:foo).match? { :foo }            # => true
Matchi::Eq.new("foo").match? { "foo" }          # => true
Matchi::Eq.new(1).match? { 1.0 }                # => false

# Types: a module, or its name resolved when the matcher runs
Matchi::BeAKindOf.new(Numeric).match? { 42 }       # => true
Matchi::BeAnInstanceOf.new(:Integer).match? { 42 } # => true
Matchi::BeAnInstanceOf.new(Numeric).match? { 42 }  # => false

# Numeric proximity; a non-Numeric actual value fails
Matchi::BeWithin.new(0.01).of(0.3).match? { 0.1 + 0.2 } # => true

# Patterns and predicates
Matchi::Match.new(/^foo/).match? { "foobar" }            # => true
Matchi::Satisfy.new { |v| v > 41 }.match? { 42 }         # => true
Matchi::Predicate.new(:be_empty).match? { [] }           # => true (calls empty?)
Matchi::Predicate.new(:have_key, :a).match? { { a: 1 } } # => true (calls has_key?(:a))

# Exceptions, by class or by name, optionally with a message (String or Regexp)
Matchi::RaiseException.new(ZeroDivisionError).match? { 1 / 0 }               # => true
Matchi::RaiseException.new("Errno::ENOENT").match? { File.read("/missing") } # => true
Matchi::RaiseException.new(ZeroDivisionError, /by 0/).match? { 1 / 0 }       # => true

# State changes, observed through a public method
list = []
Matchi::Change.new(list, :length).match? { list << 1 }                # => true
Matchi::Change.new(list, :length).by(2).match? { list.push(1, 2) }    # => true
Matchi::Change.new(list, :length).by_at_least(1).match? { list << 1 } # => true
Matchi::Change.new(list, :length).by_at_most(1).match? { list << 1 }  # => true

list = []
Matchi::Change.new(list, :length).to(1).match? { list << 1 }         # => true
Matchi::Change.new(list, :length).from(1).to(2).match? { list << 1 } # => true
```

`BeWithin.new(delta)` and `Change#from(value)` are builders, not matchers: they do not respond to `match?` until `of` or `to` completes them.

Arguments are validated when the matcher is built (`ArgumentError`); a name is resolved when the matcher runs (`NameError`, or `TypeError` when the constant is not a module, or not an exception class for `RaiseException`). A block is always required by `match?`. Whatever the actual value or an observed method raises propagates; `RaiseException` rescues what its block raises, within the limits below, not what its message filter or the resolution of its name raises.

`RaiseException` rescues an exception of the expected class, and any `StandardError`, `ScriptError`, `SystemStackError` or `SystemExit` (the exceptions [Defi](https://fixrb.dev/gems/defi/) keeps too), which it then compares with the expected class. Anything else, an `Interrupt`, a signal, a `NoMemoryError`, the exception with which an enclosing `Timeout` ends its block, goes through as it would with any other matcher, unless that is the class expected: `RaiseException.new(Interrupt)` rescues an `Interrupt`. An unexpected `exit` inside the block is the wrong exception, so `false`, not the end of the process.

`Change` observes a value: when the observed method returns the same unfrozen object twice (an `attr_reader` on a mutated array, say), `match?` raises instead of reporting no change. Observe `items.length`, or use `to`.

## Writing a matcher

Any object that responds to `match?` with a block and to `to_s` is a matcher:

```ruby
class BePositive
  def match?
    yield.positive?
  end

  def to_s
    "be positive"
  end
end

BePositive.new.match? { 42 } # => true
```

Every matcher in Matchi follows two rules, which are worth keeping in your own:

- **The expected value receives the comparison.** `Matchi::Eq.new(a).match? { b }` evaluates `a.eql?(b)`, never `b.eql?(a)`, so an actual value that redefines `eql?` cannot pass; since `Hash#eql?` hands the comparison back to an operand of another class, `Eq` also requires the two values to be of the same class. Classes are compared with `Module#===`, the class of the actual value is read with `Kernel#class` bound to it, and `BeWithin` only subtracts core numbers, for the same reason.
- **A predicate answers `true` or `false`.** `Satisfy` and `Predicate` raise a `TypeError` on any other value instead of treating it as truthy.

Two matchers depend on the honesty of the object under test, because they use values it produces: `Predicate` calls one of its methods, and `Change` (with `by`, `by_at_least`, `by_at_most`) compares two values returned by the observed method, including the subtraction between them. So does the message filter of `RaiseException`, which reads the exception's own message. `Change#to` and `from … to` compare with the expected value and do not.

A class or an exception given by name (`:Duck`, `"Errno::ENOENT"`) is resolved from `Object` when the matcher runs, so a specification can be written before the class it describes is loaded. An `autoload` or an `Object.const_missing` defined by the code under test takes part in that resolution, so a name does not carry the guarantee a module does. Names are ASCII constant paths; `"::Integer"` is not accepted.

## Differences from RSpec

If you come from RSpec or Minitest, these will surprise you:

- `Eq` is RSpec's `eql`, not its `eq`: it compares with `eql?`, so `1` is not `1.0`, and a value object that only defines `==` never matches. Define `eql?` and `hash` on it, or use `Satisfy`. `Integer#==` hands the comparison to the other operand, which is why Matchi does not use it.
- `Match` takes a `Regexp` only. For a literal substring, `Matchi::Match.new(Regexp.new(Regexp.escape("a.b")))`.
- `RaiseException` is `raise_error`; it needs an exception class, or its name, and takes an optional message. It does not rescue an `Interrupt`, a signal, a `NoMemoryError` or the exception with which an enclosing `Timeout` ends its block, unless that is the class expected, where `raise_error` rescues every `Exception`.
- `Change#to` demands a change: a value already equal to the target does not pass. `Change` without a refinement needs the observed method to return a value, not the mutated object.
- `Predicate` only calls a method of the actual value: `be_nil` calls `nil?`, but `be_truthy`, `be_falsey` and `be_a` are not predicates and do not exist. Use `Be.new(nil)`, `Satisfy`, `BeAKindOf`.
- There is no `and`, `or`, `not_to` or `all`: compose in your framework, with plain booleans.

## Changes in 6.0

- `RaiseException` no longer rescues every `Exception`: it rescues the expected class, and any `StandardError`, `ScriptError`, `SystemStackError` or `SystemExit`, which it compares with the expected class. An `Interrupt`, a signal, a `NoMemoryError` or the exception with which an enclosing `Timeout` ends its block goes through unless that is the class expected, where 5.0 reported it as a failed match. `RaiseException.new(Exception)` still rescues everything, as asked.
- The message filter of `RaiseException` and `Match` compare a plain copy of the actual `String`: a subclass could answer `valid_encoding?` for it and turn the comparison into an error.

## Changes in 5.0

- `BeAKindOf`, `BeAnInstanceOf` and `RaiseException` accept a module directly, so anonymous classes work. A name is still accepted; it must be a constant path (`"Foo::bar"` is rejected at construction) and resolve to a module, or a class for `BeAnInstanceOf` and an exception class for `RaiseException`. `BeAnInstanceOf` rejects a module that is not a class.
- `RaiseException` compares with `Module#===` and always answers `true` or `false`; `Module#<=` could answer `nil` and let the exception control the comparison. A non-exception class is rejected at construction. An expected message, `String` or `Regexp`, can be given.
- `Match` accepts a `Regexp` only, and fails on an actual value that is neither a `String` nor a `Symbol`, or whose encoding is invalid or incompatible. With a `String` pattern, the actual value would have become the regular expression.
- `Eq`, `Change#to` and `from … to` require the actual value to be of the class of the expected value, so that `Hash#eql?` cannot hand the comparison to the object under test.
- `Satisfy` requires a `true` or `false` answer (`TypeError`), as `Predicate` already did. The error names the class of the answer, never its `inspect`.
- `Predicate` and `Change` reach the object under test through `Kernel#public_send`: a private or protected predicate is now a `NoMethodError`. `Change` accepts a `String` method name and no longer checks `respond_to?` at construction; a missing method is a `NoMethodError` when the matcher runs.
- `BeWithin::Of` only subtracts an `Integer`, a `Float`, a `Rational` or a `BigDecimal`; any other actual value fails, including a user-defined `Numeric` that could control the subtraction through `coerce`. Deltas and expected values, there and in `by`, `by_at_least`, `by_at_most`, must be finite real numbers (`NaN`, infinities and `Complex` are rejected).
- `BeWithin` without `of` and `Change#from` without `to` no longer respond to `match?`.
- `from … to` compares with `eql?`, like `to` and `Eq` already did; `to` requires a change; both always evaluate the block. `Change` raises a `TypeError` when the observed method returns the same unfrozen object twice: in particular, asserting that an attribute holding an unfrozen object (a `Time`, an `Array`) did not change now raises instead of answering `false`. The three `by` refinements are one class, `Change::Delta`; `Change::From::To` is `Change::FromTo`.
- Descriptions are stable: `Change#to_s` names the observed class and method (`change Array#length`), an anonymous class reads `an anonymous class`, and no `to_s` calls `inspect` on an object under test.
- Error messages are rewritten and all read `X must be … (got: …)`; `Predicate::PREFIXES` is gone.
- The `Matchi` helper module removed in 4.2 is not back: `Matchi` is a namespace. Frameworks define their own helpers.
- Ruby 3.3 or later.

## Versioning

Matchi follows [Semantic Versioning 2.0](https://semver.org/).

## License

The [gem](https://rubygems.org/gems/matchi) is available as open source under the terms of the [MIT License](https://github.com/fixrb/matchi/raw/main/LICENSE.md).

## Sponsors

This project is sponsored by [Sashité](https://sashite.com/)
