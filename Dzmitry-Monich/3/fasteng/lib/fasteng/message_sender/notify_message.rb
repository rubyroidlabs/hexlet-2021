# frozen_string_literal: true

module Fasteng
  module MessageSender
    module NotifyMessage
      module_function

      def send(bot_api, chat_id, message)
        bot_api.send_message(chat_id: chat_id, text: message, parse_mode: 'Markdown')
      end
    end
  end
end
