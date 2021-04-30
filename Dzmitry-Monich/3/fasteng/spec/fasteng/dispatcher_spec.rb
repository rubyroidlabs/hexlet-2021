# frozen_string_literal: true

require 'fasteng'

describe Fasteng::Dispatcher do
  let(:from) { double('from', { id: Faker::Number.number(digits: 9) }) }
  let(:chat) { double('chat', { id: from.id }) }
  let(:bot_api) { double('bot_api') }

  describe 'User registration' do
    let(:message) { double('message', text: '/start', from: from, chat: chat) }
    let(:welcome_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome] }

    before do
      allow(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: welcome_message)
    end

    it 'user added in database' do
      expect { described_class.call(bot_api, message) }.to change(User, :count).from(0).to(1)
    end

    it 'user gets status registered' do
      described_class.call(bot_api, message)

      expect(User.first.status).to eq 'registered'
    end
  end

  describe 'User gets schedule' do
    context 'when answer valid' do
      let(:message) { double('message', text: '5', from: from, chat: chat) }
      let(:accepted_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:accept] }

      before do
        allow(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: accepted_message)

        @user = create(:user, telegram_id: from.id, status: 'registered')
      end

      it 'user gets schedule' do
        expect { described_class.call(bot_api, message) }.not_to change(User, :count)
        expect(User.find(@user.id).status).to eq 'scheduled'
      end
    end

    context 'when answer not valid' do
      let(:message) { double('message', text: 'what?', from: from, chat: chat) }
      let(:dialog_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome_dialog] }

      before do
        allow(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: dialog_message)

        @user = create(:user, telegram_id: from.id, status: 'registered')
      end

      it 'user not get schedule' do
        described_class.call(bot_api, message)

        expect(User.find(@user.id)).to have_attributes(
          status: 'registered',
          schedule: nil,
          upcoming_time: nil
        )
      end
    end
  end

  describe 'User gets notification (definition)' do
    context 'when user confirms notification' do
      let(:message) { double('message', text: '😄', from: from, chat: chat) }
      let(:confirm_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:done] }
      let!(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

      before do
        allow(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: confirm_message)
      end

      it 'user status changed to scheduled' do
        described_class.call(bot_api, message)

        expect(User.find(user.id).status).to eq 'scheduled'
      end
    end

    context 'when user not confirm notification' do
      let(:message) { double('message', text: 'wrong', from: from, chat: chat) }
      let!(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

      it 'user status left the same' do
        described_class.call(bot_api, message)

        expect(User.find(user.id).status).to eq 'waiting'
      end
    end
  end
end
