# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "match")

matcher = Matchi::Match.new(/^foo/)

raise unless matcher.match? { "foobar" }
raise if matcher.match? { "barfoo" }
raise unless matcher.to_s == "match /^foo/"

# Symbols are matched too; anything else fails without raising.
raise unless matcher.match? { :foobar }
raise if matcher.match? { 42 }
raise if matcher.match? { nil }
raise if matcher.match? { BasicObject.new }

# An invalid or incompatible encoding fails instead of raising.
raise if matcher.match? { "foo\xff" }
raise if Matchi::Match.new(/é/).match? { "\xC3\xA9".b }
raise if matcher.match? { "foo".encode("UTF-16LE") }
raise unless Matchi::Match.new(/é/).match? { "é" }

# A subclass of String has no say: the comparison reads a plain copy.
class MatchiTestLiarString < String
  def valid_encoding? = true
  def match?(*) = true
  def to_s = "foo"
end
raise if matcher.match? { MatchiTestLiarString.new("bar") }
raise if matcher.match? { MatchiTestLiarString.new("foo\xff") }
raise unless matcher.match? { MatchiTestLiarString.new("foobar") }

# An object pretending to be a string is not matched.
pretender = Object.new
def pretender.to_str = "foobar"
def pretender.is_a?(_klass) = true
raise if matcher.match? { pretender }

# Only a Regexp is accepted: with a String pattern, the actual value would
# become the regular expression.
["foo", :foo, 42, nil, Object.new].each do |expected|
  Matchi::Match.new(expected)
  raise "expected ArgumentError for #{expected.inspect}"
rescue ArgumentError
  nil
end

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
