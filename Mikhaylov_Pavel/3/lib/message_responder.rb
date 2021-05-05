# frozen_string_literal: true

require_relative 'message_sender'
require_relative '../models/user'
require 'pry'

class MessageResponder
  attr_reader :message, :bot, :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
  end

  def response
    ms = MessageSender.new(bot, message)
    @user = User.find_or_create_by(
      telegram_id: message.from.id,
      name: message.from.first_name
    )
    case message.text
    when '/start'
      ms.greeting
    else
      if (1..6).cover?(message.text.to_i)
        ms.accept
        user.words_per_day = message.text.to_i
        user.save
      else
        ms.wrong_number
      end
    end
  end

  # def response
  #   conversation = MessageSender.new(bot, message)
  #   case new_user?
  #   when true
  #     conversation.greeting
  #     @user = User.find_or_create_by(
  #       telegram_id: message.from.id,
  #       name: message.from.first_name
  #     )
  #   when false
  #     conversation.existing_user
  #   end
  # end
end
