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
            text: I18n.t(:greeting_new, name: @user.name)
          )
        elsif @user.session_stopped?
          @user.start_session!
          MessageSender.send(
            user: @user,
            text: I18n.t(:greeting, name: @user.name)
          )
        end
        @user
      end
    end
  end
end
