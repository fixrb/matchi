# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'be_true'

matcher = Matchi::Matchers::BeTrue::Matcher.new

# It is expected to be true
raise unless matcher.matches? { true }

# It is expected to be false
raise if matcher.matches? { 'foo' }

# It returns this string
raise unless matcher.to_s == 'be_true'

# It returns this representation
raise unless matcher.inspect == 'BeTrue()'

# It returns this hash
raise unless matcher.to_h == { BeTrue: [] }
