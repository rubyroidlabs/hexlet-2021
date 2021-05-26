# frozen_string_literal: true

require_relative '../models/user'
require_relative 'actions'

class MessageSender
  attr_reader :options, :message

  def initialize(options)
    @options = options
    @message = options[:message]
  end

  def send_answer
    case message.text
    when '/start'
      Actions::Greeting.new(options).call
    when /[1-6]/
      Actions::Accept.new(options).call
    when /[1-9][0-9]+|[7-9]/
      Actions::WrongNumber.new(options).call
    end
  end
end
