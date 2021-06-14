# frozen_string_literal: true

require 'telegram/bot'
require_relative '../models/user'
require_relative '../models/word'

Dotenv.load

module Actions
  RESPONSES = YAML.safe_load(File.read('phrases.yml')).with_indifferent_access

  BOT = Telegram::Bot::Api.new(ENV['TOKEN'])

  attr_reader :bot, :message

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
  end

  class Greeting
    include Actions

    def call
      record_user!
      greeting
    end

    def record_user!
      User.find_or_create_by!(
        telegram_id: message.from.id,
        name: message.from.first_name
      )
    end

    def greeting
      Actions::BOT.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:greeting]
      )
    end
  end

  class Accept
    include Actions

    def call
      user = User.find_by(telegram_id: message.from.id)
      user.update!(words_per_day: message.text.to_i)
      user.learn! unless user.learning?
      accept
    end

    def accept
      Actions::BOT.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:accept]
      )
    end
  end

  class WrongNumber
    include Actions

    def call
      wrong_number
    end

    def wrong_number
      Actions::BOT.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:wrong_number]
      )
    end
  end

  class Continue
    include Actions

    def call
      continue
      user = User.find_by(telegram_id: message.from.id)
      user.learn!
    end

    def continue
      Actions::BOT.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:continue]
      )
    end
  end

  class Stop
    include Actions

    def call
      user = User.find_by(telegram_id: message.from.id)
      user.stop!
      stop
    end

    def stop
      Actions::BOT.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:stop]
      )
    end
  end

  class SendWord
    def self.send(word, user)
      Actions::BOT.send_message(
        chat_id: user.telegram_id,
        text: word.to_s
      )
    end
  end

  class SendReminder
    def self.send(user)
      Actions::BOT.send_message(
        chat_id: user.telegram_id,
        text: Actions::RESPONSES[:remind]
      )
    end
  end
end
