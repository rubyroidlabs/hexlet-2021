# frozen_string_literal: true

require_relative 'acceptable_emojis'
require_relative './actions/accept'
require_relative './actions/greeting'
require_relative './actions/wrong_number'
require_relative './actions/continue'
require_relative './actions/stop'

class MessageSender
  EMOJIS = AcceptableEmojis.list
  attr_reader :options, :message

  def initialize(options)
    @options = options
    @message = options[:message]
  end

  def send_answer
    case message.text
    when '/start'
      Actions::Greeting.new(options).call
    when /^[1-6]{1}$/
      Actions::Accept.new(options).call
    when /[1-9][0-9]+|[7-9]/
      Actions::WrongNumber.new(options).call
    when get_emoji_if_emoji(message.text)
      Actions::Continue.new(options).call
    when '/stop'
      Actions::Stop.new(options).call
    end
  end

  def get_emoji_if_emoji(emoji)
    emoji if EMOJIS.include?(message.text)
  end
end
