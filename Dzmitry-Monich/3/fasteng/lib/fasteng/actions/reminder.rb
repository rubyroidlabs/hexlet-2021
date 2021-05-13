# frozen_string_literal: true

module Fasteng
  module Actions
    class Reminder < Base
      def call
        return unless user.miss_time?(actual_time)

        send(:missed)
      end
    end
  end
end
