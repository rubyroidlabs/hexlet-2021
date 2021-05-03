# frozen_string_literal: true

module Fasteng
  module Actions
    class Reminder < Base
      def call
        send(:missed)
      end
    end
  end
end
