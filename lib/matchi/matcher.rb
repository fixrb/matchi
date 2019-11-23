# frozen_string_literal: true

module Matchi
  # Collection of matcher classes.
  module Matcher
  end
end

Dir[File.join(File.dirname(__FILE__), 'matcher', '*.rb')].each do |fname|
  require_relative fname
end
