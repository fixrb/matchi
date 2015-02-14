Gem::Specification.new do |spec|
  spec.name          = 'matchi'
  spec.version       = File.read('VERSION.semver')
  spec.authors       = ['Cyril Wack']
  spec.email         = ['contact@cyril.email']

  spec.summary       = 'Collection of matchers.'
  spec.description   = 'Collection of expectation matchers for Ruby.'
  spec.homepage      = 'https://github.com/fixrb/matchi'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(/^test\//) }
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',    '~> 1.8'
  spec.add_development_dependency 'rake',       '~> 10.0'
  spec.add_development_dependency 'yard',       '~> 0.8'
  spec.add_development_dependency 'simplecov',  '~> 0.9.1'
  spec.add_development_dependency 'rubocop',    '~> 0.29'
end
