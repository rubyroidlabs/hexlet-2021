# frozen_string_literal: true

require 'pathname'
require 'pry'
require 'active_record'
require 'dotenv/load'
require 'telegram/bot'

require_relative 'fasteng/logging'
require_relative 'fasteng/dictionary_manager'
require_relative 'fasteng/app'
require_relative 'fasteng/dispatcher'
require_relative 'fasteng/database_connector'
require_relative 'fasteng/message_sender'
require_relative 'fasteng/notify_handler'
require_relative 'fasteng/application_controller'
require_relative 'fasteng/polling_controller'
require_relative 'fasteng/webhook_controller'
require_relative 'fasteng/config'

module Fasteng
  class << self
    attr_writer :config

    def root_path
      Pathname.new(File.expand_path('..', __dir__))
    end

    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
end
