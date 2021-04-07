require 'pathname'
require_relative './checker/application'
require_relative './checker/filter'
require_relative './checker/parser'

module Checker
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
