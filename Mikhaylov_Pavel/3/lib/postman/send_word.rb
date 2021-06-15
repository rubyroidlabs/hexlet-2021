# frozen_string_literal: true

require './models/user'
require_relative '../bot'
require_relative '../actions/base'
require_relative '../../models/user'
require_relative '../../models/word'

module Postman
  class SendWord < Actions::Base
    def self.send(word, user)
      BOT.send_message(
        chat_id: user.telegram_id,
        text: word.to_s
      )
    end
  end
end
