# frozen_string_literal: true

require_relative 'lib/url_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = 'url_analyzer'
  spec.version       = UrlAnalyzer::VERSION
  spec.authors       = ['Stanislav Dzisiak']
  spec.email         = ['stanislav.dzisiak@outlook.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'Url analyzer'
  spec.description   = 'Cli utility for url analysis.'
  spec.homepage      = 'https://github.com/corsicanec82/hexlet-2021/tree/master/Stanislav_Dzisiak/2'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/corsicanec82/hexlet-2021/tree/master/Stanislav_Dzisiak/2'
  spec.metadata['changelog_uri'] = 'https://github.com/corsicanec82/hexlet-2021/tree/master/Stanislav_Dzisiak/2'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'slop', '~> 4.8.2'
end
