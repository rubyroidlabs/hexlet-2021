# frozen_string_literal: true

require_relative 'message_sender'
require_relative 'teacher'
require 'pry'

class MessageResponder
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def response
    MessageSender.new(options).send_answer
  end
end
