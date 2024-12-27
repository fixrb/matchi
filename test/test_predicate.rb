# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "predicate")

matcher = Matchi::Predicate.new("be_empty")

# It is expected to be true
raise unless matcher.matches? { [] }

# It is expected to be false
raise if matcher.matches? { [4, 9] }

# It returns this string
raise unless matcher.to_s == "be empty"

# It returns this representation
raise unless matcher.inspect == "Matchi::Predicate(be_empty, *[], **{}, &nil)"

matcher = Matchi::Predicate.new("have_key", :foo)

# It is expected to be true
raise unless matcher.matches? { { foo: 42 } }

# It is expected to be false
raise if matcher.matches? { { bar: 4 } }

# It returns this string
raise unless matcher.to_s == "have key :foo"

# It returns this representation
raise unless matcher.inspect == "Matchi::Predicate(have_key, *[:foo], **{}, &nil)"

matcher = Matchi::Predicate.new(:be_swimmer, foo: "bar")

class Duck
  def swimmer?(**_options)
    true
  end
end

# It is expected to be true
raise unless matcher.matches? { Duck.new }

class Rhinoceros
  def swimmer?(**_options)
    false
  end
end

# It is expected to be false
raise if matcher.matches? { Rhinoceros.new }

# It returns this string

raise unless matcher.to_s == 'be swimmer foo: "bar"'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Predicate(be_swimmer, *[], **{:foo=>"bar"}, &nil)'
