# frozen_string_literal: true

require 'dotenv'

Dotenv.load

class Bot
  def self.token
    ENV['TOKEN']
  end

  def self.instance
    Telegram::Bot::Api.new(token)
  end
end
