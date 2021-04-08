require 'pathname'
require_relative './checker/application'
require_relative './checker/parser'
require_relative './checker/filter'
require_relative './checker/http_service'

module Checker
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
