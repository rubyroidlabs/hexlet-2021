# frozen_string_literal: true

require './models/user'
require './lib/message_sender'
require_relative './bot_action'

module Learner
  module Actions
    class Stop < BotAction
      def call
        @user.stop_session!
        MessageSender.send(user: @user, text: 'Пока!')
      end
    end
  end
end
