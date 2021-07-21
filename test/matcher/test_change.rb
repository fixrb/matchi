# frozen_string_literal: false

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "change")

object = []
matcher = Matchi::Matcher::Change.new(object, :length).by(2)

# It returns the symbol
raise unless matcher.class.to_sym == :change

# It is expected to be false
raise if matcher.matches? { object }
raise if matcher.matches? { object << "foo" }

# It is expected to be true
raise unless matcher.matches? { object << "bar" << "baz" }

# It returns this string
raise unless matcher.to_s == "change by 2"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::Change::By(2)"

# It returns an expected given value
raise unless matcher.expected == 2

object = []
matcher = Matchi::Matcher::Change.new(object, :length).by_at_least(2)

# It returns the symbol
raise unless matcher.class.to_sym == :change

# It is expected to be false
raise if matcher.matches? { object }
raise if matcher.matches? { object << "foo" }

# It is expected to be true
raise unless matcher.matches? { object << "bar" << "baz" }
raise unless matcher.matches? { object << 1 << 2 << 3 }

# It returns this string
raise unless matcher.to_s == "change by at least 2"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::Change::ByAtLeast(2)"

# It returns an expected given value
raise unless matcher.expected == 2

object = []
matcher = Matchi::Matcher::Change.new(object, :length).by_at_most(1)

# It returns the symbol
raise unless matcher.class.to_sym == :change

# It is expected to be true
raise unless matcher.matches? { object }
raise unless matcher.matches? { object << "foo" }

# It is expected to be false
raise if matcher.matches? { object << "bar" << "baz" }

# It returns this string
raise unless matcher.to_s == "change by at most 1"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::Change::ByAtMost(1)"

# It returns an expected given value
raise unless matcher.expected == 1

object = "foo"
matcher = Matchi::Matcher::Change.new(object, :to_s).from("foo").to("FOO")

# It returns the symbol
raise unless matcher.class.to_sym == :change

# It is expected to be true
raise unless matcher.matches? { object.upcase! }

# It is expected to be false
raise if matcher.matches? { object.upcase }

# It returns this string
raise unless matcher.to_s == 'change from "foo" to "FOO"'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Matcher::Change::From("foo")::To("FOO")'

# It returns an expected given value
raise unless matcher.expected == "FOO"

object = "foo"
matcher = Matchi::Matcher::Change.new(object, :to_s).to("FOO")

# It returns the symbol
raise unless matcher.class.to_sym == :change

# It is expected to be false
raise if matcher.matches? { object.upcase }

# It is expected to be true
raise unless matcher.matches? { object.upcase! }

# It returns this string
raise unless matcher.to_s == 'change to "FOO"'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Matcher::Change::To("FOO")'

# It returns an expected given value
raise unless matcher.expected == "FOO"
