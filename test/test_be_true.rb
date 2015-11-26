require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'be_true'

matcher = Matchi::Matchers::BeTrue::Matcher.new

# It is expected to be true
fail unless matcher.matches? { true }

# It is expected to be false
fail if matcher.matches? { 'foo' }

# It returns this string
fail unless matcher.to_s == 'be_true'

# It returns this hash
fail unless matcher.to_h == { BeTrue: [] }
