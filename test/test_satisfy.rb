# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "satisfy")

expected = ->(value) { value == 42 }
matcher = Matchi::Satisfy.new(&expected)

# It is expected to be true
raise unless matcher.matches? { 42 }

# It is expected to be false
raise if matcher.matches? { :boom }

# It returns this string
raise unless matcher.to_s == "satisfy &block"

# It returns this representation
raise unless matcher.inspect == "Matchi::Satisfy(&block)"

# It returns the given expected value
raise unless matcher.expected == expected
