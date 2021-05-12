# frozen_string_literal: true

require './models/user'
require_relative '../message_sender'
require_relative './bot_action'

module Learner
  module Actions
    class Start < BotAction
      def call
        if @user.unregistred?
          MessageSender.send(
            user: @user,
            text: "Привет, #{@user.name}! Я бот, который помогает учить новые английские слова каждый день.
  Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?"
          )
        elsif @user.session_stopped?
          @user.start_session!
          MessageSender.send(
            user: @user,
            text: "Привет, #{@user.name}!"
          )
        end
        @user
      end
    end
  end
end
