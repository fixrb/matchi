# frozen_string_literal: true

require_relative File.join("..", "support", "coverage")
require_relative File.join("..", "..", "lib", "matchi", "matcher", "raise_exception")

expected = ZeroDivisionError
matcher = Matchi::Matcher::RaiseException.new(expected)

# It returns the symbol
raise unless matcher.class.to_sym == :raise_exception

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
raise unless matcher.to_s == "raise_exception ZeroDivisionError"

# It returns this representation
raise unless matcher.inspect == "Matchi::Matcher::RaiseException(ZeroDivisionError)"

# It returns an expected given value
raise unless matcher.expected == expected
