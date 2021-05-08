# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require_relative 'connection'
require_relative 'lib/message_responder'
require_relative 'models/user'
require_relative 'models/word'
require_relative 'models/learned_word'
require 'pry'

Dotenv.load

TOKEN = ENV['TOKEN']

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }
    # binding.pry
    MessageResponder.new(options).response
  end
end
