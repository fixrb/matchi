# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'be_nil'

matcher = Matchi::Matchers::BeNil::Matcher.new

# It is expected to be true
raise unless matcher.matches? { nil }

# It is expected to be false
raise if matcher.matches? { 'foo' }

# It returns this string
raise unless matcher.to_s == 'be_nil'

# It returns this representation
raise unless matcher.inspect == 'BeNil()'

# It returns this hash
raise unless matcher.to_h == { BeNil: [] }
