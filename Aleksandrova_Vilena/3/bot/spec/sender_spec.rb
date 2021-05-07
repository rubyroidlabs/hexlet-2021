# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require_relative '../lib/sender'
require_relative '../lib/loader'
require 'recursive-open-struct'

RSpec.describe Sender do
  before { Singleton.__init__(Bot) }
  describe '#for' do
    let(:req) { RecursiveOpenStruct.new({ message: { text: '/start', from: { id: 11_111 } } }) }
    context 'checks the start message' do
      it 'greeting response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:welcome])
      end
    end
    context 'checks the telegram_id' do
      it 'right telegram_id' do
        expect(Sender.for(req).telegram_id).to eq(11_111)
      end
    end
    context 'checks the db user' do
      it 'db user' do
        Sender.for(req)
        user = User.by_id(11_111)
        expect(!user.empty?).to be_truthy
      end
    end
    context 'checks the stop message' do
      let(:req) { RecursiveOpenStruct.new({ message: { text: '/stop', from: { id: 11_111 } } }) }
      it 'bye response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:bye])
      end
    end
    context 'checks the pause message' do
      let(:req) { RecursiveOpenStruct.new({ message: { text: '/pause', from: { id: 11_111 } } }) }
      it 'pause response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:pause])
      end
    end
    context 'checks the repeat_qty' do
      let(:req) { RecursiveOpenStruct.new({ message: { text: '3', from: { id: 11_111 } } }) }
      it 'qty response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:registered])
      end
    end
    context 'checks db repeat_qty' do
      it 'db quantity' do
        user = User.by_id(11_111).first
        expect(user.repeat_qty).to eq(0)
      end
    end
    context 'checks the accept response' do
      let(:req) { RecursiveOpenStruct.new({ message: { text: '🙂', from: { id: 11_111 } } }) }
      it 'accept response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:accepted])
      end
    end
    context 'checks the spam response' do
      let(:req) { RecursiveOpenStruct.new({ message: { text: 'Hello world', from: { id: 11_111 } } }) }
      it 'spam response' do
        expect(Sender.for(req).msg).to eq(Bot.instance.answer[:spam])
      end
    end
  end
end
