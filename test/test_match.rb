require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

matcher = Matchi::Match.new(/^foo/)

# It is expected to be true
fail unless matcher.matches? { 'foobar' }

# It is expected to be false
fail if matcher.matches? { 'bar' }

# It returns this string
fail unless matcher.to_s == 'match /^foo/'

# It returns this hash
fail unless matcher.to_h == { Match: [/^foo/] }
