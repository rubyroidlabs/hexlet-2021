# frozen_string_literal: true

require 'json'
require_relative 'webhook_controller/sinatra_base'

module Fasteng
  class WebhookController < BaseController
    def initialize
      super

      @url = Fasteng.config.url
    end

    def run
      setup

      sinatra_controller.run!
    end

    private

    def sinatra_controller
      SinatraBase
        .set(:bot_api, bot.api)
        .post '/telegram' do
          request.body.rewind
          data = JSON.parse(request.body.read)
          message = Telegram::Bot::Types::Update.new(data).message
          logger.info "[#{message.chat.id}] #{message.from.username}: #{message.text}"

          Dispatcher.call(settings.bot_api, message)

          status 200
        end
      SinatraBase
    end

    def setup
      bot.api.set_webhook(url: "#{url}/telegram")
    end
  end
end
