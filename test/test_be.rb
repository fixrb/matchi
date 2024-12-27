# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be")

matcher = Matchi::Be.new(:foo)

# It is expected to be true
raise unless matcher.matches? { :foo }

# It is expected to be false
raise if matcher.matches? { :bar }

# It returns this string
raise unless matcher.to_s == "be :foo"

# It returns this representation
raise unless matcher.inspect == "Matchi::Be(:foo)"
