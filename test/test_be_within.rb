# frozen_string_literal: false

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_within")

# Test that BeWithin#match? raises NotImplementedError when called directly
begin
  Matchi::BeWithin.new(0.5).match? { 42 }
  raise "Expected NotImplementedError to be raised"
rescue NotImplementedError => e
  # Verify the error message is helpful
  raise unless e.message == "BeWithin is not a complete matcher. Use BeWithin#of to create a valid matcher."
end

matcher = Matchi::BeWithin.new(1).of(41)

# It is expected to be false
raise if matcher.match? { 39 }
raise if matcher.match? { 43 }

# It is expected to be true
raise unless matcher.match? { 40 }
raise unless matcher.match? { 41 }
raise unless matcher.match? { 42 }

# It returns this string
raise unless matcher.to_s == "be within 1 of 41"
