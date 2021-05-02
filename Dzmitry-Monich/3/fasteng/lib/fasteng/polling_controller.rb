# frozen_string_literal: true

module Fasteng
  class PollingController < ApplicationController
    def run
      setup

      bot.listen do |message|
        logger.info "[#{message.chat.id}] #{message.from.username}: #{message.text}"
        Thread.new(message) { |msg| Dispatcher.call(bot.api, msg) }
      end
    end

    private

    def setup
      return if webhook_missed?

      bot.api.deleteWebhook
    end

    def webhook_missed?
      webhook_info = bot.api.getWebhookInfo
      webhook_info['result']['url'].empty?
    end
  end
end
