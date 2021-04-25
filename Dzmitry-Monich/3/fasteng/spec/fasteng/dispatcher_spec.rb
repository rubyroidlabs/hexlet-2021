# frozen_string_literal: true

require 'fasteng'

describe Fasteng::Dispatcher do
  let(:from) { double('from', { id: 'abc' }) }
  let(:chat) { double('chat', { id: 'www' }) }
  let(:bot_api) { double('bot_api') }

  context 'when user is new' do
    let(:message) { double('message', text: '/start', from: from, chat: chat) }
    let(:welcome_message) do
      'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
      'Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?'
    end

    subject { Fasteng::Dispatcher.new(bot_api, message) }

    before do
      allow(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: welcome_message)
    end

    it 'user added in database' do
      expect { subject.dispatch }.to change(User, :count).from(0).to(1)
    end

    it 'user get status registered' do
      subject.dispatch
      expect(User.first.status).to eq 'registered'
    end
  end

  context 'when user is registered' do
    let(:message) { double('message', text: '5', from: from, chat: chat) }
    let(:accepted_message) { 'Принято' }

    subject { Fasteng::Dispatcher.new(bot_api, message) }

    before do
      allow(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: accepted_message)

      @user = create(:user, telegram_id: 'abc', status: 'registered')
    end

    it 'user not added in database' do
      expect { subject.dispatch }.not_to change(User, :count)
    end

    it 'user get status scheduled' do
      subject.dispatch
      expect(User.find(@user.id).status).to eq 'scheduled'
    end
  end
end
