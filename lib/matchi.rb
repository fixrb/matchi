Dir[File.join File.dirname(__FILE__), 'matchi', '*.rb'].each do |fname|
  require_relative fname
end

# Namespace for the Matchi library.
module Matchi
end
