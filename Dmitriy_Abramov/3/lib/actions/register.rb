# frozen_string_literal: true

require './models/user'
require './lib/message_sender'
require_relative './bot_action'

module Learner
  module Actions
    class Register < BotAction
      def call
        return unless @user&.unregistred?

        count = @message.text.to_i

        return MessageSender.send(user: @user, text: 'Я не умею учить больше чем 6 словам. Давай еще раз?') if count > 6

        @user.update!(daily_words_count: count)
        @user.register!
        MessageSender.send(user: @user, text: 'Принято.')
      end
    end
  end
end
