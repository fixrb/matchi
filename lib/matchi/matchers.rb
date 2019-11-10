# frozen_string_literal: true

module Matchi
  # Collection of matchers.
  module Matchers
  end
end

::Dir[::File.join ::File.dirname(__FILE__), 'matchers', '*.rb'].each do |fname|
  require_relative fname
end
