# frozen_string_literal: true

require 'fasteng'

describe Fasteng::Dispatcher do
  let(:from) { double('from', { id: Faker::Number.number(digits: 9) }) }
  let(:chat) { double('chat', { id: from.id }) }
  let(:bot_api) { double('bot_api') }

  describe 'User registration' do
    let(:message) { double('message', text: '/start', from: from, chat: chat) }
    let(:welcome_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome] }

    it 'user registers' do
      allow(Fasteng::MessageSender::ReplyMessage)
        .to receive(:send)
        .with(bot_api, chat.id, :welcome)

      expect { described_class.call(bot_api, message) }.to change(User, :count).from(0).to(1)
      expect(User.first.status).to eq 'registered'
    end

    it 'user gets Welcome message' do
      expect(bot_api)
        .to receive(:send_message)
        .with(chat_id: chat.id, text: welcome_message)

      described_class.call(bot_api, message)
    end
  end

  describe 'User gets schedule of getting definitions' do
    context 'when answer valid' do
      let(:message) { double('message', text: '5', from: from, chat: chat) }
      let(:accepted_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:accept] }
      let!(:user) { create(:user, telegram_id: from.id, status: 'registered') }

      it 'user gets schedule' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, chat.id, :accept)

        expect { described_class.call(bot_api, message) }.not_to change(User, :count)
        expect(User.find(user.id).status).to eq 'scheduled'
      end

      it 'user gets Accept message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: accepted_message)

        described_class.call(bot_api, message)
      end
    end

    context 'when answer not valid' do
      let(:message) { double('message', text: 'what?', from: from, chat: chat) }
      let(:dialog_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome_dialog] }
      let!(:user) { create(:user, telegram_id: from.id, status: 'registered') }

      it 'user not get schedule' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, chat.id, :welcome_dialog)

        described_class.call(bot_api, message)

        expect(User.find(user.id)).to have_attributes(
          status: 'registered', schedule: nil, upcoming_time: nil
        )
      end

      it 'user gets :welcome_dialog message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: dialog_message)

        described_class.call(bot_api, message)
      end
    end
  end

  describe 'User receives definition' do
    context 'when user make feedback' do
      let(:message) { double('message', text: '😄', from: from, chat: chat) }
      let(:confirm_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:done] }
      let!(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

      it 'user status changed to scheduled' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, chat.id, :done)

        described_class.call(bot_api, message)

        expect(User.find(user.id).status).to eq 'scheduled'
      end

      it 'user gets :done message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: chat.id, text: confirm_message)

        described_class.call(bot_api, message)
      end
    end

    context 'when user not confirm notification' do
      let(:message) { double('message', text: 'wrong', from: from, chat: chat) }
      let!(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

      it 'user status not changed' do
        described_class.call(bot_api, message)

        expect(User.find(user.id).status).to eq 'waiting'
      end
    end
  end
end
