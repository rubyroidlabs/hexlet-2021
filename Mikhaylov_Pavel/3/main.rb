# frozen_string_literal: true

require 'dotenv'
require 'telegram/bot'
require_relative 'connection'
require_relative 'lib/message_responder'
require_relative 'models/user'

Dotenv.load

TOKEN = ENV['TOKEN']

ANSERS = %w[
  sdfdsfsdf
  sdfewrwewr
  123213
  qqqqqqq
  ggggggg
].freeze

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }

    # case message.text
    # when '/start'
    #   bot.api.send_message(
    #     chat_id: message.chat.id,
    #     text: "Hello, #{message.from.first_name}")
    # else
    #   bot.api.send_message(
    #     chat_id: message.chat.id,
    #     text: ANSERS.sample)
    # end
    MessageResponder.new(options).response
  end
end
