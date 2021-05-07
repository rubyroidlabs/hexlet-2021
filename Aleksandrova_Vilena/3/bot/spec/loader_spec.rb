# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require_relative '../lib/loader'

RSpec.describe Bot do
  before { Singleton.__init__(Bot) }
  context 'telegram api' do
    it 'returns telegram bot api' do
      expect(Bot.instance.api).not_to eq nil
    end
  end

  context 'bot answers' do
    it 'returns bot answers' do
      expect(Bot.instance.answer).not_to eq nil
    end
  end
end
