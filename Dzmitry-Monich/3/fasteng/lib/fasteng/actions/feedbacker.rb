# frozen_string_literal: true

module Fasteng
  module Actions
    class Feedbacker < Base
      def call
        return unless definition_received?(message.text)

        user.update!(status: 'scheduled')
        send(:done)
      end

      private

      def definition_received?(answer)
        answer == '😄'
      end
    end
  end
end
