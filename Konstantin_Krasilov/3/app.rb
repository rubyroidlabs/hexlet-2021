# frozen_string_literal: true

require 'telegramAPI'
require 'sinatra'
require 'dotenv'
require 'sinatra/activerecord'
require_relative 'config/connection'
require_relative 'app/models/user'
require_relative 'app/services/telegram/conversation'

Dotenv.load

api = TelegramAPI.new ENV['TELEGRAM_TOKEN']

post '/telegram' do
  status 200

  request.body.rewind
  data = JSON.parse(request.body.read)

  chat_id = data['message']['chat']['id']
  message = data['message']['text']

  user = User.find_or_create_by(telegram_id: chat_id)

  case message
  when '/start'
    user.send_max_word!
    api.sendMessage(chat_id, Telegram::Conversation::RESPONSE[:welcome])
  else
    api.sendMessage(chat_id, Telegram::Conversation.new(user, message).call) unless user.conversation_break?
  end

  # Return an empty json, to say "ok" to Telegram
  '{}'
end

api.setWebhook(ENV['URL'])
