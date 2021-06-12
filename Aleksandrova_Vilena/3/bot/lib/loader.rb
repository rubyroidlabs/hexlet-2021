# frozen_string_literal: true

require 'singleton'
require 'dotenv/load'
require_relative 'logging'
require_relative 'answers'

class Bot
  include Singleton
  include Logging
  include Answers

  attr_accessor :api, :answer

  def initialize
    if ENV['BOT_API_TOKEN'].nil?
      logger.error 'environmental variable BOT_API_KEY not set'
      return
    end
    @api = Telegram::Bot::Api.new(ENV['BOT_API_TOKEN'])
    @answer = load_answers
  end
end
