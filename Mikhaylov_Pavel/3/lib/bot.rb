# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'

Dotenv.load

class Bot
  def self.token
    token = ENV['TOKEN']
    raise StandardError, 'Token not set' unless token
    token
  end

  def self.instance
    Telegram::Bot::Api.new(token)
  end
end
