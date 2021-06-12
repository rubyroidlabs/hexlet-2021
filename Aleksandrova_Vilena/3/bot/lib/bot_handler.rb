# frozen_string_literal: true

require 'telegram/bot'
require 'json'
require 'ostruct'
require_relative 'logging'
require_relative 'json_parser'
require_relative 'loader'
require_relative 'sender'
require 'byebug'

class BotHandler
  include Logging
  include JsonParser

  def initialize(request_body)
    @msg = hash_to_struct(load(request_body))
  end

  def run
    Talking.send(@msg)
  end
end
