# frozen_string_literal: false

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "change")

object = []
matcher = Matchi::Change.new(object, :length).by(2)

# It is expected to be false
raise if matcher.match? { object }
raise if matcher.match? { object << "foo" }

# It is expected to be true
raise unless matcher.match? { object << "bar" << "baz" }

# It returns this string
raise unless matcher.to_s == "change by 2"

object = []
matcher = Matchi::Change.new(object, :length).by_at_least(2)

# It is expected to be false
raise if matcher.match? { object }
raise if matcher.match? { object << "foo" }

# It is expected to be true
raise unless matcher.match? { object << "bar" << "baz" }
raise unless matcher.match? { object << 1 << 2 << 3 }

# It returns this string
raise unless matcher.to_s == "change by at least 2"

# Test by_at_most with various scenarios
object = []
matcher = Matchi::Change.new(object, :length).by_at_most(1)

# No change is acceptable
raise unless matcher.match? { object }

# Change by exactly the maximum is acceptable
raise unless matcher.match? { object << "foo" }

# Change by less than maximum is acceptable
raise unless matcher.match? { object.clear }

# Change by more than maximum is not acceptable
raise if matcher.match? { object << "bar" << "baz" }

# Test with negative changes
object = [1, 2, 3]
matcher = Matchi::Change.new(object, :length).by_at_most(2)

# Negative change within limit is acceptable
raise unless matcher.match? { object.pop }

# Multiple negative changes within limit are acceptable
raise unless matcher.match? { 2.times { object.pop } }

# Test with zero as maximum
object = []
matcher = Matchi::Change.new(object, :length).by_at_most(0)

# No change is acceptable
raise unless matcher.match? { object }

# Any change is not acceptable
raise if matcher.match? { object << "foo" }
raise if matcher.match? { object << 1 << 2 }

# Test with different numeric types
object = []
matcher = Matchi::Change.new(object, :length).by_at_most(1.0) # Float instead of Integer

# Should work the same way
raise unless matcher.match? { object }
raise unless matcher.match? { object << "foo" }
raise if matcher.match? { object << "bar" << "baz" }

# It returns this string
raise unless matcher.to_s == "change by at most 1.0"

object = "foo"
matcher = Matchi::Change.new(object, :to_s).from("foo").to("FOO")

# It is expected to be true
raise unless matcher.match? { object.upcase! }

# It is expected to be false
raise if matcher.match? { object.upcase }

# It returns this string
raise unless matcher.to_s == 'change from "foo" to "FOO"'

object = "foo"
matcher = Matchi::Change.new(object, :to_s).to("FOO")

# It is expected to be false
raise if matcher.match? { object.upcase }

# It is expected to be true
raise unless matcher.match? { object.upcase! }

# It returns this string
raise unless matcher.to_s == 'change to "FOO"'
