# frozen_string_literal: true

require 'telegram/bot'
require 'yaml'

module Learner
  class MessageSender
    def self.send(options)
      config = File.open('./config/secrets.yml')
      token = YAML.safe_load(config)['token']
      bot = Telegram::Bot::Api.new(token)
      bot.send_message(chat_id: options[:user].uid, text: options[:text])
    end
  end
end
