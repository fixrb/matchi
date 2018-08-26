# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'be_false'

matcher = Matchi::Matchers::BeFalse::Matcher.new

# It is expected to be true
raise unless matcher.matches? { false }

# It is expected to be false
raise if matcher.matches? { 'foo' }

# It returns this string
raise unless matcher.to_s == 'be_false'

# It returns this hash
raise unless matcher.to_h == { BeFalse: [] }
