# frozen_string_literal: true

require './models/user'
require_relative '../bot'

module Actions
  class Base
    BOT = Bot.instance
    RESPONSES = YAML.safe_load(File.read('phrases.yml'))

    attr_reader :message

    def initialize(options)
      @message = options[:message]
    end

    def call
      send_message(class_name_to_snake_case)
    end

    def send_message(type)
      BOT.send_message(
        chat_id: message.chat.id,
        text: RESPONSES[type]
      )
    end

    def find_user
      User.find_by(telegram_id: message.from.id)
    end

    private

    def class_name_to_snake_case
      underscore(self.class.name.split('::').last)
    end

    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/')
                      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .tr('-', '_')
                      .downcase
    end
  end
end
