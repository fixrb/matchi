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

# It returns this representation
raise unless matcher.inspect == "Matchi::Change::By(2)"

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

# It returns this representation
raise unless matcher.inspect == "Matchi::Change::ByAtLeast(2)"

object = []
matcher = Matchi::Change.new(object, :length).by_at_most(1)

# It is expected to be true
raise unless matcher.match? { object }
raise unless matcher.match? { object << "foo" }

# It is expected to be false
raise if matcher.match? { object << "bar" << "baz" }

# It returns this string
raise unless matcher.to_s == "change by at most 1"

# It returns this representation
raise unless matcher.inspect == "Matchi::Change::ByAtMost(1)"

object = "foo"
matcher = Matchi::Change.new(object, :to_s).from("foo").to("FOO")

# It is expected to be true
raise unless matcher.match? { object.upcase! }

# It is expected to be false
raise if matcher.match? { object.upcase }

# It returns this string
raise unless matcher.to_s == 'change from "foo" to "FOO"'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Change::From::To("foo", "FOO")'

object = "foo"
matcher = Matchi::Change.new(object, :to_s).to("FOO")

# It is expected to be false
raise if matcher.match? { object.upcase }

# It is expected to be true
raise unless matcher.match? { object.upcase! }

# It returns this string
raise unless matcher.to_s == 'change to "FOO"'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Change::To("FOO")'
