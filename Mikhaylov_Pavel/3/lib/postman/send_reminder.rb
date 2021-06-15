# frozen_string_literal: true

require './models/user'
require_relative '../bot'
require_relative '../actions/base'
require_relative '../../models/user'
require_relative '../../models/word'

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
