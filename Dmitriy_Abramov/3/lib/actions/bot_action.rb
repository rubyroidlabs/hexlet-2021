# frozen_string_literal: true

require './models/user'
require './lib/message_sender'

module Learner
  module Actions
    class BotAction
      def self.call(user, message)
        new(user, message).call
      end

      def initialize(user, message)
        @user = user
        @message = message
      end
    end
  end
end
