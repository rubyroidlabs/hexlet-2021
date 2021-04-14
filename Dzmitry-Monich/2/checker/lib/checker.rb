# frozen_string_literal: true

require 'pathname'
require_relative './checker/application'
require_relative './checker/parser'
require_relative './checker/filter'
require_relative './checker/http_service'
require_relative './checker/printer'

module Checker
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
