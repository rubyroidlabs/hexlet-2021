# frozen_string_literal: true

module Fasteng
  module Actions
    class Scheduler < Base
      def call
        if user.add_schedule(message.text)
          send(:accept)
        else
          send(:welcome_dialog)
        end
      end
    end
  end
end
