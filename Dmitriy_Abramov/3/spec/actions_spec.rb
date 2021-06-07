# frozen_string_literal: true

require './lib/actions/start'
require './lib/actions/register'
require './lib/actions/reply'
require './lib/actions/stop'
require './lib/message_sender'

describe Learner::Actions do
  before do
    allow(Learner::MessageSender).to receive(:send)
  end

  let(:message) { double('message') }

  describe 'Start' do
    context 'new user' do
      let(:user) { create(:user) }

      it 'sends welcome message' do
        expect(Learner::MessageSender).to receive(:send)
        described_class::Start.call(user, message)
      end
    end

    context 'exiting user' do
      let(:user) { create(:user_session_stopped) }

      it 'sends welcome message message' do
        expect(Learner::MessageSender).to receive(:send)
        described_class::Start.call(user, message)
      end

      it 'changes status' do
        described_class::Start.call(user, message)
        expect(user.session_started?).to eq true
      end
    end
  end

  describe 'Register' do
    let(:user) { create(:user) }

    context 'too many words' do
      let(:message) { double('message', text: 9) }

      it 'not registers' do
        described_class::Register.call(user, message)
        expect(user.reload.session_started?).to eq false
      end

      it 'not sets daily words' do
        described_class::Register.call(user, message)
        expect(user.daily_words_count).to eq nil
      end

      it 'sends message' do
        expect(Learner::MessageSender).to receive(:send)
        described_class::Register.call(user, message)
      end
    end

    context 'enough words' do
      let(:message) { double('message', text: 3) }

      it 'registers' do
        described_class::Register.call(user, message)
        expect(user.reload.session_started?).to eq true
      end

      it 'sets daily words' do
        described_class::Register.call(user, message)
        expect(user.daily_words_count).to eq 3
      end

      it 'sends message' do
        expect(Learner::MessageSender).to receive(:send)
        described_class::Register.call(user, message)
      end
    end
  end

  describe 'Reply' do
    let(:user) { create(:user_waiting) }

    it 'sets state' do
      described_class::Reply.call(user, message)
      expect(user.session_started?).to eq true
    end

    it 'sends message' do
      expect(Learner::MessageSender).to receive(:send)
      described_class::Reply.call(user, message)
    end
  end

  describe 'Stop' do
    let(:user) { create(:user_session_started) }

    it 'sets state' do
      described_class::Stop.call(user, message)
      expect(user.reload.session_stopped?).to eq true
    end

    it 'sends message' do
      expect(Learner::MessageSender).to receive(:send)
      described_class::Stop.call(user, message)
    end
  end
end
