# frozen_string_literal: true

require 'pathname'
require_relative 'fasteng/logging'
require_relative 'fasteng/app'
require_relative 'fasteng/message_responder'
require_relative 'fasteng/database_connector'

module Fasteng
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
