# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "be_nil")

expected = nil
matcher = Matchi::Matcher::BeNil.new

# It returns the symbol
raise unless matcher.class.to_sym == :be_nil

# It is expected to be true
raise unless matcher.matches? { nil }

# It is expected to be false
raise if matcher.matches? { "foo" }

# It returns this string
raise unless matcher.to_s == "be_nil"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::BeNil()"

# It returns an expected given value
raise unless matcher.expected == expected
