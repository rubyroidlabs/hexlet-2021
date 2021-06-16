# frozen_string_literal: true

module Fasteng
  module Actions
    class DefinitionSender < Base
      def call
        return unless user.upcoming_time_equal?(actual_time)

        definition = DictionaryManager::DictionarySelector.call(user)
        if definition
          user.receive_definition!(definition)
          notify(definition)
        else
          send(:end_game)
        end
      end
    end
  end
end
