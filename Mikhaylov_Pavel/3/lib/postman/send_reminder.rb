# frozen_string_literal: true

require_relative '../bot'
require_relative '../actions/base'

module Postman
  class SendReminder < Actions::Base
    def self.send(user)
      BOT.send_message(
        chat_id: user.telegram_id,
        text: RESPONSES['remind']
      )
    end
  end
end
