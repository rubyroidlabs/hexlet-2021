# frozen_string_literal: true

require 'telegram/bot'
require 'unicode/emoji'
require_relative 'config/connection'
require_relative 'lib/message_sender'
require_relative 'models/learned_word'
require_relative 'models/user'
require_relative 'models/word'
require_relative 'lib/emoji_list'
require_relative 'lib/bot'

Telegram::Bot::Client.run(Bot.token) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }
    MessageSender.new(options).send_answer
  end
end
