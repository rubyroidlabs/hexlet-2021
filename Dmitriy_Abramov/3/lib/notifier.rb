# frozen_string_literal: true

require 'telegram/bot'
require './lib/message_sender'
require './models/word'
require './models/learned_word'

module Learner
  class Notifier
    def self.send_words
      users = User.session_started
      return unless users.size.positive?

      users
        .reject(&:done_for_today?)
        .each do |user|
          word = user.learn
          MessageSender.send(user: user, text: word.to_s)
          user.wait_for_answer!
        end
    end

    def self.remind
      users = User.waiting_for_answer
      return unless users.size.positive?

      users
        .select(&:need_to_remind?)
        .each do |user|
          MessageSender.send(user: user, text: '
    Кажется ты был слишком занят, и пропустил слово выше? Дай мне знать что у тебя все хорошо.
    ')
        end
    end
  end
end
