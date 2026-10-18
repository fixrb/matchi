# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_within")

matcher = Matchi::BeWithin.new(1).of(42)

raise unless matcher.match? { 41 }
raise unless matcher.match? { 43 }
raise unless matcher.match? { 42.5 }
raise if matcher.match? { 40 }
raise unless matcher.to_s == "be within 1 of 42"

raise unless Matchi::BeWithin.new(0.01).of(0.3).match? { 0.1 + 0.2 }
raise unless Matchi::BeWithin.new(0).of(42).match? { 42 }
raise unless Matchi::BeWithin.new(1).of(Rational(1, 2)).match? { Rational(3, 2) }

# Only a core number can be within an interval: an object, even a Numeric,
# that defines coerce to fool the subtraction is rejected before it is subtracted.
cheater = Object.new
def cheater.coerce(number) = [number, number]
raise if matcher.match? { cheater }

class MatchiTestEvilNumber < Numeric
  def coerce(_number) = [0, 0]
  def to_f = 42.0
end
raise if matcher.match? { MatchiTestEvilNumber.new }

liar = Object.new
def liar.class = Integer
def liar.is_a?(_klass) = true
def liar.coerce(number) = [number, number]
raise if matcher.match? { liar }

raise if matcher.match? { "42" }
raise if matcher.match? { nil }
raise if matcher.match? { Float::NAN }
raise if matcher.match? { Complex(42, 0) }
raise if matcher.match? { BasicObject.new }

# BigDecimal is loaded only now: the matcher works without it, as above,
# and accepts it once it is there.
require "bigdecimal"
raise unless matcher.match? { BigDecimal("42.5") }
raise if matcher.match? { BigDecimal("44") }

# Without `of`, there is no matcher, but there is a description.
raise if Matchi::BeWithin.new(1).respond_to?(:match?)
raise unless Matchi::BeWithin.new(1).to_s == "be within 1"

# Arguments are finite real numbers.
[-1, "1", nil, Float::NAN, Float::INFINITY, Complex(1, 0), Complex(1, 1)].each do |delta|
  Matchi::BeWithin.new(delta)
  raise "expected ArgumentError for #{delta.inspect}"
rescue ArgumentError
  nil
end

["42", nil, Float::NAN, -Float::INFINITY, Complex(42, 1)].each do |expected|
  Matchi::BeWithin.new(1).of(expected)
  raise "expected ArgumentError for #{expected.inspect}"
rescue ArgumentError
  nil
end
raise unless Matchi::BeWithin.new(1).of(-42).match? { -42.5 }

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
