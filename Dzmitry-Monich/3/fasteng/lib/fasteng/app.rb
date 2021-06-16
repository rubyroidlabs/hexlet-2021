# frozen_string_literal: true

module Fasteng
  class App
    class << self
      include Logging

      def run
        init

        controller = Fasteng.const_get("#{Fasteng.config.controller.capitalize}Controller")
        logger.info 'Bot starting...'
        controller.run
      end

      private

      def init
        DatabaseConnector.call
        require_models
        DictionaryManager::DictionaryCreator.call
      end

      def require_models
        Dir["#{Fasteng.root_path}/models/**/*.rb"].sort.each { |file| require file }
      end
    end
  end
end
