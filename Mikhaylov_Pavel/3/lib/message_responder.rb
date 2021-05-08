# frozen_string_literal: true

require_relative 'message_sender'

class MessageResponder
  attr_reader :message, :bot

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
  end

  def response
    MessageSender.new(bot, message).send_answer
    # Teacher.new(message)
  end
end
