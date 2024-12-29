# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "eq")

matcher = Matchi::Eq.new("foo")

# It is expected to be true
raise unless matcher.match? { "foo" }

# It is expected to be false
raise if matcher.match? { "bar" }

# It returns this string
raise unless matcher.to_s == 'eq "foo"'
