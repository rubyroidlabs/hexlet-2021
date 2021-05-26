# frozen_string_literal: true

require 'pry'
require 'telegram/bot'
require_relative '../models/user'
require_relative '../models/word'

Dotenv.load

module Actions
  RESPONSES = {
    greeting: 'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
    'Давай сперва определимся сколько слов в день (от 1 до 6) ты хочешь узнавать?',
    wrong_number: 'Я не умею учить больше чем 6 словам. Давай еще раз?',
    accept: 'Принято',
    remind: 'Кажется ты был слишком занят, и пропустил слово выше? Дай мне знать что у тебя все хорошо.',
    continue: 'Вижу что ты заметил слово! Продолжаем учиться дальше!'
  }.freeze

  BOT = Telegram::Bot::Api.new(ENV['TOKEN'])

  attr_reader :bot, :message

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
  end

  class Greeting
    include Actions

    def call
      record_user
      greeting
    end

    def record_user
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
      bot.api.send_message(
        chat_id: message.chat.id,
        text: Actions::RESPONSES[:wrong_number]
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
