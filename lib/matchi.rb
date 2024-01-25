# frozen_string_literal: true

# A collection of damn simple expectation matchers.
#
# @api public
module Matchi
end

Dir[File.join(File.dirname(__FILE__), "matchi", "*.rb")].each do |fname|
  require_relative fname
end
