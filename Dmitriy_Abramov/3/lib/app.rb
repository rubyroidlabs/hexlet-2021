# frozen_string_literal: true

require './db/connection'
require_relative './actions/start'
require_relative './actions/stop'
require_relative './actions/reply'
require_relative './actions/register'

module Learner
  class App
    def respond(message)
      user = get_user(message)

      case message.text
      when '/start'
        Actions::Start.call(user, message)

      when '/stop'
        Actions::Stop.call(user, message)

      when /[1-6]{1}$/
        Actions::Register.call(user, message)

      when /\p{Emoji}{1}$/
        Actions::Reply.call(user, message)
      end
    end

    private

    def get_user(message)
      User.find_by(uid: message.chat.id) || create_user(message)
    end

    def create_user(message)
      raise StandartError, 'Sorry, no anonyms allowed' if !message.from.first_name && !message.from.username

      User.create!(uid: message.chat.id, name: message.from.first_name || message.from.username)
    end
  end
end
