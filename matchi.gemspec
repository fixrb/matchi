# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name         = 'matchi'
  spec.version      = File.read('VERSION.semver').chomp
  spec.author       = 'Cyril Kato'
  spec.email        = 'contact@cyril.email'
  spec.summary      = 'Collection of matchers.'
  spec.description  = 'Collection of expectation matchers for Ruby.'
  spec.homepage     = 'https://github.com/fixrb/matchi'
  spec.license      = 'MIT'
  spec.files        = Dir['LICENSE.md', 'README.md', 'lib/**/*']

  spec.add_development_dependency 'bundler',    '~> 2.0'
  spec.add_development_dependency 'rake',       '~> 13.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'simplecov',  '~> 0.17'
  spec.add_development_dependency 'yard',       '~> 0.9'
end
