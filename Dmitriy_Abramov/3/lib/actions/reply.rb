# frozen_string_literal: true

require './models/user'
require './lib/message_sender'
require_relative './bot_action'

module Learner
  module Actions
    class Reply < BotAction
      def call
        return unless @user&.waiting_for_answer?

        @user.recieve_answer!
        if @user.done_for_today?
          MessageSender.send(user: @user, text: 'На сегодня все. Молодец!')
        else
          MessageSender.send(user: @user, text: 'Вижу что ты заметил слово! Продолжаем учиться дальше!')
        end
      end
    end
  end
end
