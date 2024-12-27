# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_an_instance_of")

# When expected object is a class
matcher = Matchi::BeAnInstanceOf.new(Symbol)

# It is expected to be true
raise unless matcher.match? { :foo }

# It is expected to be false
raise if matcher.match? { "boom" }

# It returns this string
raise unless matcher.to_s == "be an instance of Symbol"

# It returns this representation
raise unless matcher.inspect == "Matchi::BeAnInstanceOf(Symbol)"

# When expected object is a symbol
matcher = Matchi::BeAnInstanceOf.new(:Symbol)

# It is expected to be true
raise unless matcher.match? { :foo }

# It is expected to be false
raise if matcher.match? { "boom" }

# It returns this string
raise unless matcher.to_s == "be an instance of Symbol"

# It returns this representation
raise unless matcher.inspect == "Matchi::BeAnInstanceOf(Symbol)"
