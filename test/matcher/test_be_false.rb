# frozen_string_literal: true

require_relative File.join('..', 'support', 'coverage')
require_relative File.join('..', '..', 'lib', 'matchi', 'matcher', 'be_false')

expected = nil
matcher = Matchi::Matcher::BeFalse.new(expected)

# It returns the symbol
raise unless matcher.class.to_sym == :be_false

# It is expected to be true
raise unless matcher.matches? { false }

# It is expected to be false
raise if matcher.matches? { 'foo' }

# It returns this string
raise unless matcher.to_s == 'be_false'

# It returns this representation
raise unless matcher.inspect == 'Matchi::Matcher::BeFalse()'

# It returns an expected given value
raise unless matcher.expected == expected
