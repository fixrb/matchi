# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "matchi"
  spec.version                = File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "Framework-agnostic matchers for secure, elegant Ruby testing 🤹"

  spec.description = <<~DESC
    Matchi is a framework-agnostic Ruby library that provides a comprehensive set of expectation matchers for elegant and secure testing. Its design focuses on simplicity, security, and extensibility, making it easy to integrate with any testing framework. The library offers a rich collection of built-in matchers for common testing scenarios while maintaining a clear, consistent API that follows Ruby best practices. With minimal setup required and support for custom matchers, Matchi enables developers to write more reliable and maintainable tests.
  DESC

  spec.homepage               = "https://github.com/fixrb/matchi"
  spec.license                = "MIT"
  spec.files                  = Dir["LICENSE.md", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.1.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
