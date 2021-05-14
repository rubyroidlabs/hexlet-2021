# frozen_string_literal: true

describe Fasteng::Dispatcher do
  let(:from) { double('from', { id: Faker::Number.number(digits: 9) }) }
  let(:message) { double('message', from: from) }
  let(:bot_api) { double('bot_api') }

  describe 'User registration' do
    let(:user) { create(:user, telegram_id: from.id, status: 'new') }

    it 'triggers Registerer action' do
      expect(Fasteng::Actions::Registerer)
        .to receive(:call)
        .with(bot_api, user, message)

      described_class.call(bot_api, message)
    end
  end

  describe 'User scheduling' do
    let(:user) { create(:user, telegram_id: from.id, status: 'registered') }

    it 'triggers Scheduler action' do
      expect(Fasteng::Actions::Scheduler)
        .to receive(:call)
        .with(bot_api, user, message)

      described_class.call(bot_api, message)
    end
  end

  describe 'User learning' do
    let(:user) { create(:user, telegram_id: from.id, status: 'waiting') }

    it 'triggers Feedbacker action' do
      expect(Fasteng::Actions::Feedbacker)
        .to receive(:call)
        .with(bot_api, user, message)

      described_class.call(bot_api, message)
    end
  end
end
