require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'match'

matcher = Matchi::Matchers::Match::Matcher.new(/^foo/)

# It is expected to be true
raise unless matcher.matches? { 'foobar' }

# It is expected to be false
raise if matcher.matches? { 'bar' }

# It returns this string
raise unless matcher.to_s == 'match /^foo/'

# It returns this hash
raise unless matcher.to_h == { Match: [/^foo/] }
