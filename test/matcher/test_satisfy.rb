# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "satisfy")

expected = ->(value) { value == 42 }
matcher = Matchi::Matcher::Satisfy.new(&expected)

# It returns the symbol
raise unless matcher.class.to_sym == :satisfy

# It is expected to be true
raise unless matcher.matches? { 42 }

# It is expected to be false
raise if matcher.matches? { :boom }

# It returns this string
raise unless matcher.to_s == "satisfy &block"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::Satisfy(&block)"

# It returns an expected given value
raise unless matcher.expected == expected
