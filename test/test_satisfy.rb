# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "satisfy")

expected = ->(value) { value == 42 }
matcher = Matchi::Satisfy.new(&expected)

# It is expected to be true
raise unless matcher.match? { 42 }

# It is expected to be false
raise if matcher.match? { :boom }

# It returns this string
raise unless matcher.to_s == "satisfy &block"
