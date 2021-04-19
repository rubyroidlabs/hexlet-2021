# frozen_string_literal: true

require_relative 'lib/checker/version'

Gem::Specification.new do |spec|
  spec.name          = 'checker'
  spec.version       = Checker::VERSION
  spec.authors       = ['Dmitry Abramov']
  spec.email         = ['']

  spec.summary       = '"Check rails-based apps avialibility"'
  spec.homepage      = 'https://github.com/Dein1'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
