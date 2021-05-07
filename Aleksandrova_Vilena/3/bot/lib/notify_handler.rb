# frozen_string_literal: true

require_relative 'logging'
require_relative 'reply_factory'
require_relative 'answers'
require_relative 'generator'
require_relative 'models/user'
require_relative 'models/learned_definition'
require_relative 'models/definition'
require 'telegram/bot'

class NotifyHandler
  include Logging
  def self.perform
    logger.info 'starting cron notifications'
    Job.new.notify_users
  end
end

class Job
  include Logging
  include Answers
  include Generator

  def initialize
    @api = Telegram::Bot::Api.new(ENV['BOT_API_TOKEN'])
    @answers = load_answers
    @telegram_id = 0
    @msg = nil
  end

  def notify_users
    User.where(status: User.statuses[:active]).each do |user|
      @telegram_id = user.telegram_id
      studied_word = LearnedDefinition.by_user_id(user.id).order(created_at: :desc).first
      if new?(user.repeat_qty, studied_word.received_qty, studied_word.sent_qty)
        send_new_word
        next
      end
      next if word_missed?(studied_word.received_qty, studied_word.sent_qty)

      send_word(studied_word)
      studied_word.update(sent_qty: studied_word.sent_qty + 1)
    end
  end

  private

  def send_new_word
    @api.sendMessage(chat_id: @telegram_id, text: @answers[:new])
    sleep 1
    generate_word
    @api.sendMessage(chat_id: @telegram_id, text: @msg)
  end

  def new?(qty, sent_qty, received_qty)
    return true if qty == sent_qty && qty == received_qty

    false
  end

  def send_word(studied_word)
    voc_word = Definition.where(id: studied_word.definition_id).first
    @msg = "#{voc_word.word.upcase} - #{voc_word.description}"
    @api.sendMessage(chat_id: @telegram_id, text: @msg)
  end

  def word_missed?(received_qty, sent_qty)
    @api.sendMessage(chat_id: @telegram_id, text: @answers[:warning]) if received_qty != sent_qty
    received_qty != sent_qty
  end
end
