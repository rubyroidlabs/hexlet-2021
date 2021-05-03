# frozen_string_literal: true

module Fasteng
  module Actions
    class DefinitionSender < Base
      def call
        if message
          user.receive_definition!(message)
          notify(message)
        else
          send(:end_game)
        end
      end
    end
  end
end
