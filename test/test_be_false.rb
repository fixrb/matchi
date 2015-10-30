require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

matcher = Matchi::BeFalse.new

# It is expected to be true
fail unless matcher.matches? { false }

# It is expected to be false
fail if matcher.matches? { 'foo' }

# It returns this string
fail unless matcher.to_s == 'be_false'

# It returns this hash
fail unless matcher.to_h == { BeFalse: [] }
