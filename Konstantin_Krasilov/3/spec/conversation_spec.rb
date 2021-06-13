# frozen_string_literal: true

require_relative '../app/services/telegram/conversation'
require_relative 'support/factory_bot'
require_relative 'factories/user'

describe Telegram::Conversation do
  let(:user) { build(:user) }

  describe '.call' do
    context 'user sends the maximum number of words included in the range' do
      it 'return success response' do
        user.send_max_word!
        message = '6'
        conversation = Telegram::Conversation.new(user, message)

        expect(conversation.call).to eq(Telegram::Conversation::RESPONSE[:max_word_success])
      end
    end

    context 'user sends the maximum number of words outside the range' do
      it 'return error response' do
        user.send_max_word!
        message = '7'
        conversation = Telegram::Conversation.new(user, message)

        expect(conversation.call).to eq(Telegram::Conversation::RESPONSE[:max_word_error])
      end
    end

    context 'user sends a smile' do
      it 'eturn success response' do
        user.send_smiley!
        message = '😉'
        conversation = Telegram::Conversation.new(user, message)

        expect(conversation.call).to eq(Telegram::Conversation::RESPONSE[:smiley_success])
      end
    end

    context 'when not options key and link success' do
      it 'user does not send a smiley' do
        user.send_smiley!
        message = 'смайл'
        conversation = Telegram::Conversation.new(user, message)

        expect(conversation.call).to eq(Telegram::Conversation::RESPONSE[:smiley_error])
      end
    end
  end

  describe '#send_max_word' do
    context 'user sends the maximum number of words included in the range' do
      it 'change the status and write the number of words' do
        user.send_max_word!
        message = '2'
        Telegram::Conversation.new(user, message).call

        expect(user.max_words).to eq(2)
        expect(user.conversation_break?).to be true
      end
    end
  end

  describe '#send_smiley' do
    context 'user sends a smile' do
      it 'change the status' do
        user.send_smiley!
        message = '😉'
        Telegram::Conversation.new(user, message).call

        expect(user.conversation_break?).to be true
      end
    end
  end
end
