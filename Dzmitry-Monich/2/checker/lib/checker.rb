require 'pathname'
require_relative './checker/application'

module Checker
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
