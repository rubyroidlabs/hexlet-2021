# frozen_string_literal: true

require 'telegramAPI'
require 'sinatra'
require 'dotenv'

Dotenv.load

api = TelegramAPI.new ENV['TELEGRAM_TOKEN']

post '/telegram' do
  status 200

  # Return an empty json, to say "ok" to Telegram
  '{}'
end

api.setWebhook(ENV['URL'])
