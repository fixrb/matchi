Dir[File.join File.dirname(__FILE__), 'matchi', '*.rb'].each do |fname|
  require_relative fname
end

# Namespace for the Matchi library.
#
# @api public
#
# @example Match that 42 is equal to 42
#   matcher = Matchi.fetch(:Equal, 42)
#   matcher.matches? { 42 } # => true
module Matchi
  # Select a matcher from those available.
  #
  # @param [Symbol] matcher_id the name of the constant of the matcher to fetch
  # @param [Array] args parameters to initialize the class of the matcher
  #
  # @return [#matches?] the matcher
  def self.fetch(matcher_id, *args)
    const_get(matcher_id, false).new(*args)
  end
end
