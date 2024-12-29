# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "match")

matcher = Matchi::Match.new(/^foo/)

# It is expected to be true
raise unless matcher.match? { "foobar" }

# It is expected to be false
raise if matcher.match? { "bar" }

# It returns this string
raise unless matcher.to_s == "match /^foo/"
