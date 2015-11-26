require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'be_nil'

matcher = Matchi::Matchers::BeNil::Matcher.new

# It is expected to be true
fail unless matcher.matches? { nil }

# It is expected to be false
fail if matcher.matches? { 'foo' }

# It returns this string
fail unless matcher.to_s == 'be_nil'

# It returns this hash
fail unless matcher.to_h == { BeNil: [] }
