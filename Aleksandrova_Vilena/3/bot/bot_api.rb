# frozen_string_literal: true

require 'sinatra/base'
require 'telegram/bot'
require 'dotenv/load'
require_relative 'lib/loader'
require_relative 'lib/bot_handler'

class BotApi < Sinatra::Base
  post '/' do
    if Bot.instance.api
      BotHandler.new(request.body).run
      status 200
    else
      status 400
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
