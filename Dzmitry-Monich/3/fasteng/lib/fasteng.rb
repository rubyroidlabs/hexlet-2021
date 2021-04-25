# frozen_string_literal: true

require 'pathname'
require 'pry'
require_relative 'fasteng/logging'
require_relative 'fasteng/dictionary'
require_relative 'fasteng/app'
require_relative 'fasteng/dispatcher'
require_relative 'fasteng/database_handler'
require_relative 'fasteng/message_sender'

module Fasteng
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
