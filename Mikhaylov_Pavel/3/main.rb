# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require 'pry'
require_relative 'config/connection'
require_relative 'lib/message_sender'
require_relative 'models/learned_word'
require_relative 'models/user'
require_relative 'models/word'

Dotenv.load

TOKEN = ENV['TOKEN']

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }
    binding.pry
    MessageSender.new(options).send_answer
  end
end
