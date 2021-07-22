# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "raise_exception")

# When expected object is a class
matcher = Matchi::RaiseException.new(ZeroDivisionError)

# It is expected to be true
raise unless matcher.matches? { raise ZeroDivisionError }

# It is expected to be false
raise if matcher.matches? { "bar" }

# It is expected to raise
begin
  matcher.matches? { Matchi::BOOM } && raise
rescue NameError
  true
end

# It returns this string
raise unless matcher.to_s == "raise exception ZeroDivisionError"

# It returns this representation
raise unless matcher.inspect == "Matchi::RaiseException(ZeroDivisionError)"

# It returns the given expected value
raise unless matcher.expected == :ZeroDivisionError

# When expected object is a symbol
matcher = Matchi::RaiseException.new(:ZeroDivisionError)

# It is expected to be true
raise unless matcher.matches? { raise ZeroDivisionError }

# It is expected to be false
raise if matcher.matches? { "bar" }

# It is expected to raise
begin
  matcher.matches? { Matchi::BOOM } && raise
rescue NameError
  true
end

# It returns this string
raise unless matcher.to_s == "raise exception ZeroDivisionError"

# It returns this representation
raise unless matcher.inspect == "Matchi::RaiseException(ZeroDivisionError)"

# It returns the given expected value
raise unless matcher.expected == :ZeroDivisionError
