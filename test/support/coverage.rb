unless RUBY_ENGINE.eql?('rbx')
  require 'simplecov'

  SimpleCov.start do
    minimum_coverage 100
  end
end
