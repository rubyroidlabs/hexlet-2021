# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require_relative '../lib/notify_handler'
require_relative '../lib/loader'
require 'recursive-open-struct'

RSpec.describe Job do
  before { Singleton.__init__(Bot) }
  subject { described_class.new }

  describe '#generate_word' do
    context 'checks the telegranm_id' do
      it 'right telegram_id' do
        expect(subject.telegram_id).to_not eq(11_111)
      end
    end
    context 'checks a new word was generated' do
      it 'word generation' do
        subject.generate_definition(11_111)
        expect(subject.msg).to_not eq('')
      end
    end
    context 'checks if the word was sent' do
      it 'sent word' do
        subject.notify_users
        user_id = User.by_id(11_111).first.id
        word = LearnedDefinition.where(user_id: user_id).first
        expect(word.sent_qty).to eq(1)
      end
    end
  end
end
