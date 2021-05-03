# frozen_string_literal: true

module Fasteng
  module Actions
    class Scheduler < Base
      def call
        if first_answer_valid?(message.text)
          user.add_schedule!(message.text)
          send(:accept)
        else
          send(:welcome_dialog)
        end
      end

      private

      def first_answer_valid?(answer)
        (1..6).map(&:to_s).any?(answer)
      end
    end
  end
end
