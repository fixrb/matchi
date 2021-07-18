# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "be_an_instance_of")

# When expected object is a class
expected = Symbol
matcher = Matchi::Matcher::BeAnInstanceOf.new(expected)

# It returns the symbol
raise unless matcher.class.to_sym == :be_an_instance_of

# It is expected to be true
raise unless matcher.matches? { :foo }

# It is expected to be false
raise if matcher.matches? { "boom" }

# It returns this string
raise unless matcher.to_s == "be_an_instance_of Symbol"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::BeAnInstanceOf(Symbol)"

# It returns an expected given value
raise unless matcher.expected == expected

# When expected object is a symbol
expected = :Symbol
matcher = Matchi::Matcher::BeAnInstanceOf.new(expected)

# It returns the symbol
raise unless matcher.class.to_sym == :be_an_instance_of

# It is expected to be true
raise unless matcher.matches? { :foo }

# It is expected to be false
raise if matcher.matches? { "boom" }

# It returns this string
raise unless matcher.to_s == "be_an_instance_of Symbol"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::BeAnInstanceOf(Symbol)"

# It returns an expected given value
raise unless matcher.expected == self.class.const_get(expected)
