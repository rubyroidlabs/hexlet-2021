# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv'
require_relative 'config/connection'
require_relative 'lib/message_sender'
require_relative 'lib/bot'

Telegram::Bot::Client.run(Bot.token) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }
    MessageSender.new(options).send_answer
  end
end
