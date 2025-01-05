# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  # Add filter to ignore the test directory
  add_filter "/test/"
end
