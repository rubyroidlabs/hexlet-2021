# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'

Dotenv.load

class Bot
  def self.token
    ENV['TOKEN']
  end

  def self.instance
    Telegram::Bot::Api.new(token)
  end
end
