# frozen_string_literal: true

require 'fasteng'

describe Fasteng::Actions do
  let(:from) { double('from', { id: Faker::Number.number(digits: 9) }) }
  let(:bot_api) { double('bot_api') }

  describe 'User registration' do
    let(:message) { double('message', from: from) }
    let(:welcome_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome] }
    let(:user) { create(:user, telegram_id: from.id, status: 'new') }

    it 'user registers' do
      allow(Fasteng::MessageSender::ReplyMessage)
        .to receive(:send)
        .with(bot_api, user.telegram_id, :welcome)

      described_class::Registerer.call(bot_api, user, message)

      expect(User.first.status).to eq 'registered'
    end

    it 'user gets :welcome message' do
      expect(bot_api)
        .to receive(:send_message)
        .with(chat_id: user.telegram_id, text: welcome_message)

      described_class::Registerer.call(bot_api, user, message)
    end
  end

  describe 'User scheduling' do
    context 'when answer valid' do
      let(:message) { double('message', text: '5', from: from) }
      let(:accepted_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:accept] }
      let(:user) { create(:user, telegram_id: from.id, status: 'registered') }

      it 'user gets schedule' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, user.telegram_id, :accept)

        described_class::Scheduler.call(bot_api, user, message)

        expect(User.find(user.id).status).to eq 'scheduled'
      end

      it 'user gets :accept message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: from.id, text: accepted_message)

        described_class::Scheduler.call(bot_api, user, message)
      end
    end

    context 'when answer not valid' do
      let(:message) { double('message', text: 'what?', from: from) }
      let(:dialog_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:welcome_dialog] }
      let(:user) { create(:user, telegram_id: from.id, status: 'registered') }

      it 'user not gets schedule' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, user.telegram_id, :welcome_dialog)

        described_class::Scheduler.call(bot_api, user, message)

        expect(User.find(user.id)).to have_attributes(
          status: 'registered', words_count: nil, upcoming_time: nil
        )
      end

      it 'user gets :welcome_dialog message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: user.telegram_id, text: dialog_message)

        described_class::Scheduler.call(bot_api, user, message)
      end
    end
  end

  describe 'User makes feedback after receiving word' do
    let(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

    context 'when user makes feedback' do
      let(:message) { double('message', text: '😄', from: from) }
      let(:confirm_message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:done] }

      it 'user status changed to scheduled' do
        allow(Fasteng::MessageSender::ReplyMessage)
          .to receive(:send)
          .with(bot_api, user.telegram_id, :done)

        described_class::Feedbacker.call(bot_api, user, message)

        expect(User.find(user.id).status).to eq 'scheduled'
      end

      it 'user gets :done message' do
        expect(bot_api)
          .to receive(:send_message)
          .with(chat_id: user.telegram_id, text: confirm_message)

        described_class::Feedbacker.call(bot_api, user, message)
      end
    end

    context 'when user not make feedback' do
      let(:message) { double('message', text: 'wrong', from: from) }

      it 'user status not changed' do
        described_class::Feedbacker.call(bot_api, user, message)

        expect(User.find(user.id).status).to eq 'waiting'
      end
    end
  end

  describe 'User receives definition' do
    let(:definition) { create(:definition) }
    let(:user) { create(:user, telegram_id: from.id, status: 'scheduled', words_count: 3, upcoming_time: 15) }
    let(:last_messsage) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:end_game] }

    it 'user status changed to waiting' do
      allow(Fasteng::MessageSender::NotifyMessage)
        .to receive(:send)
        .with(bot_api, user.telegram_id, definition)

      described_class::DefinitionSender.call(bot_api, user, definition)

      expect(User.find(user.id).status).to eq 'waiting'
    end

    it 'user receives definition' do
      expect(Fasteng::MessageSender::NotifyMessage)
        .to receive(:send)
        .with(bot_api, user.telegram_id, definition)

      described_class::DefinitionSender.call(bot_api, user, definition)
    end

    it 'user not receives definition (there are no more of the ones)' do
      expect(bot_api)
        .to receive(:send_message)
        .with(chat_id: user.telegram_id, text: last_messsage)

      described_class::DefinitionSender.call(bot_api, user, nil)
    end
  end

  describe 'User receives notifiication about missed feedback' do
    let(:message) { Fasteng::MessageSender::ReplyMessage::MESSAGES[:missed] }
    let(:user) { create(:user, telegram_id: from.id) }

    it 'user receives message' do
      expect(bot_api)
        .to receive(:send_message)
        .with(chat_id: user.telegram_id, text: message)

      described_class::Reminder.call(bot_api, user, :missed)
    end
  end
end
