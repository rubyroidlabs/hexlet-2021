# frozen_string_literal: true

describe User, type: :model do
  describe 'associations' do
    it { should have_many(:learned_words).dependent(:destroy) }
    # it { should have_many(:words).through(:learned_words) }
  end

  describe 'validations' do
    describe 'uid' do
      context 'uniqueness' do
        before { create(:user) }

        it { should validate_uniqueness_of(:uid).case_insensitive }
      end

      context 'without uid' do
        let(:user) { build(:user, uid: nil) }

        it { expect(user).not_to be_valid }
      end
    end

    describe 'daily_words_count' do
      context 'valid parameter' do
        let(:user) { build(:user_session_started) }

        it { expect(user).to be_valid }
      end

      context 'invalid parameter' do
        let(:user) { build(:user, daily_words_count: 20) }

        it { expect(user).not_to be_valid }
      end
    end
  end

  describe '#learn' do
    before { create(:word) }
    let(:user) { create(:user_session_started) }

    it 'add learned word' do
      expect { user.learn }.to change { LearnedWord.count }.by(1)
    end
  end

  describe '#done_for_today?' do
    let(:user) { create(:user_session_started) }

    it 'false at the beginning' do
      expect(user.done_for_today?).to be false
    end

    it 'true after learning 3 words' do
      3.times do
        create(:word)
        user.learn
      end
      expect(user.done_for_today?).to be true
    end
  end

  describe '#need_to_remind?' do
    let(:user) { create(:user_waiting) }
    let(:word) { create(:word) }

    context 'just after creation' do
      before { LearnedWord.create(user_id: user.id, word_id: word.id) }

      it 'has not to be reminded' do
        expect(user.reload.need_to_remind?).to be false
      end
    end

    context 'long time ago' do
      before { LearnedWord.create(user_id: user.id, word_id: word.id, created_at: 1.day.ago) }

      it 'has to be reminded' do
        expect(user.reload.need_to_remind?).to be true
      end
    end
  end
end
