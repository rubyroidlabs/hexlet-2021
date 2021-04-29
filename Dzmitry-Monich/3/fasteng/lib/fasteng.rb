# frozen_string_literal: true

require 'pathname'
require 'pry'
require 'dotenv/load'
require 'telegram/bot'
require 'yaml'
require 'active_record'

require_relative 'fasteng/logging'
require_relative 'fasteng/dictionary_manager'
require_relative 'fasteng/app'
require_relative 'fasteng/dispatcher'
require_relative 'fasteng/database_connector'
require_relative 'fasteng/message_sender'
require_relative 'fasteng/notify_handler'

module Fasteng
  def self.root_path
    Pathname.new(File.expand_path('..', __dir__))
  end
end
