Gem::Specification.new do |spec|
  spec.name          = 'matchi'
  spec.version       = File.read('VERSION.semver')
  spec.authors       = ['Cyril Wack']
  spec.email         = ['contact@cyril.email']

  spec.summary       = 'Collection of matchers.'
  spec.description   = 'Collection of expectation matchers for Ruby.'
  spec.homepage      = 'https://github.com/fixrb/matchi'
  spec.license       = 'MIT'

  spec.files         =
    `git ls-files -z`.split("\x0").reject { |f| f.match(/%r{^test}/) }
  spec.executables   = spec.files.grep(/%r{^exe}/) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',    '~> 1.9'
  spec.add_development_dependency 'rake',       '~> 10.4'
  spec.add_development_dependency 'yard',       '~> 0.8'
  spec.add_development_dependency 'simplecov',  '~> 0.10'
  spec.add_development_dependency 'rubocop',    '~> 0.31'
end
