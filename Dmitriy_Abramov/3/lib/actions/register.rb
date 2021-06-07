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

        return MessageSender.send(user: @user, text: I18n.t(:register_error)) if count > 6

        @user.update!(daily_words_count: count)
        @user.register!
        MessageSender.send(user: @user, text: I18n.t(:register_success))
      end
    end
  end
end
