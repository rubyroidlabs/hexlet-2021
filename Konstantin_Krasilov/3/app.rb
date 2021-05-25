# frozen_string_literal: true

require 'telegramAPI'
require 'sinatra'
require 'dotenv'
require 'sinatra/activerecord'
require_relative 'config/connection'
require_relative 'app/models/user'
require_relative 'app/services/telegram/conversation'

Dotenv.load

WELCOME = 'Привет! Я бот, который помогает учить новые английские слова каждый день. Давай сперва определимся,' \
 'сколько слов в день (от 1 до 6) ты хочешь узнавать?'.freeze

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
    api.sendMessage(chat_id, WELCOME) if message.include?('/start')
  else
    api.sendMessage(chat_id, Telegram::SendMaxWord.new(user, message).call) if user.waiting_max_word?
    api.sendMessage(chat_id, Telegram::SendSmiley.new(user, message).call) if user.waiting_smiley?
  end

  # Return an empty json, to say "ok" to Telegram
  '{}'
end

api.setWebhook(ENV['URL'])
