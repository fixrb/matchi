Dir[File.join File.dirname(__FILE__), 'matchi', '*.rb'].each do |fname|
  require_relative fname
end

# Namespace for the Matchi library.
#
# @api public
#
# @example Expect 42 to be equal to 42
#   matcher = Matchi::Equal.new(42)
#   matcher.matches? { 42 } # => true
module Matchi
end
