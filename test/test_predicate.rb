# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "predicate")

matcher = Matchi::Predicate.new("be_empty")

# It is expected to be true
raise unless matcher.match? { [] }

# It is expected to be false
raise if matcher.match? { [4, 9] }

# It returns this string
raise unless matcher.to_s == "be empty"

matcher = Matchi::Predicate.new("have_key", :foo)

# It is expected to be true
raise unless matcher.match? { { foo: 42 } }

# It is expected to be false
raise if matcher.match? { { bar: 4 } }

# It returns this string
raise unless matcher.to_s == "have key :foo"

matcher = Matchi::Predicate.new(:be_swimmer, foo: "bar")

class Duck
  def swimmer?(**_options)
    true
  end
end

# It is expected to be true
raise unless matcher.match? { Duck.new }

class Rhinoceros
  def swimmer?(**_options)
    false
  end
end

# It is expected to be false
raise if matcher.match? { Rhinoceros.new }

# It returns this string

raise unless matcher.to_s == 'be swimmer foo: "bar"'
