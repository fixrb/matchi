# frozen_string_literal: false

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_within")

matcher = Matchi::BeWithin.new(1).of(41)

# It is expected to be false
raise if matcher.matches? { 39 }
raise if matcher.matches? { 43 }

# It is expected to be true
raise unless matcher.matches? { 40 }
raise unless matcher.matches? { 41 }
raise unless matcher.matches? { 42 }

# It returns this string
raise unless matcher.to_s == "be within 1 of 41"

# It returns this representation
raise unless matcher.inspect == "Matchi::BeWithin::Of(1, 41)"

# It returns the given expected value
raise unless matcher.expected == 41
