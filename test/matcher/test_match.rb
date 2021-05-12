# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "match")

expected = /^foo/
matcher = Matchi::Matcher::Match.new(expected)

# It returns the symbol
raise unless matcher.class.to_sym == :match

# It is expected to be true
raise unless matcher.matches? { "foobar" }

# It is expected to be false
raise if matcher.matches? { "bar" }

# It returns this string
raise unless matcher.to_s == "match /^foo/"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::Match(/^foo/)"

# It returns an expected given value
raise unless matcher.expected == expected
