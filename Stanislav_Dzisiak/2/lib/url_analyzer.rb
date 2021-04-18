# frozen_string_literal: true

module UrlAnalyzer
  autoload 'Cli', 'url_analyzer/cli'
  autoload 'Analyzer', 'url_analyzer/analyzer'
  autoload 'Parser', 'url_analyzer/parser'
  autoload 'Utils', 'url_analyzer/utils'
  autoload 'RequestWorker', 'url_analyzer/request_worker'
end
