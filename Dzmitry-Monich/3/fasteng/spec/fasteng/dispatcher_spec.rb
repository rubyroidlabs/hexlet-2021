# frozen_string_literal: true

require 'pathname'
require 'fasteng'

describe Fasteng::Dispatcher do
  let(:from) { double('from', { id: 'abc' }) }
  let(:chat) { double('chat', { id: 'www' }) }
  let(:message) { double('message', text: '5', from: from, chat: chat) }
  let(:bot_api) { double('bot_api') }
  let(:message_sender) { Fasteng::MessageSender.new(bot_api, message) }

  context 'without user in db' do
    before do
      allow(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: 'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
          'Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?')
    end

    subject { Fasteng::Dispatcher.new(message, message_sender) }

    it 'creates user' do
      expect { subject.dispatch }.to change(User, :count).by(1)
    end
  end

  context 'with user in db' do
    before do
      allow(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: 'Принято')

      @user = create(:user, telegram_id: 'abc', status: 'registered')
    end

    subject { Fasteng::Dispatcher.new(message, message_sender) }

    it 'not creates user' do
      expect { subject.dispatch }.not_to change(User, :count)
    end

    it 'updated user status' do
      subject.dispatch
      expect(User.find(@user.id).status).to eq 'scheduled'
    end
  end
end
