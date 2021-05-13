# frozen_string_literal: true

module Fasteng
  module Actions
    class Scheduler < Base
      def call
        user.add_schedule(message.text) ? send(:accept) : send(:welcome_dialog)
      end
    end
  end
end
