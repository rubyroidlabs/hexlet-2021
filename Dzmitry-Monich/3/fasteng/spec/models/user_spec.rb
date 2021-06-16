# frozen_string_literal: true

describe User, type: :model do
  describe 'Validation' do
    before { create(:user) }

    it { should validate_uniqueness_of(:telegram_id).case_insensitive }
    it { should validate_presence_of(:telegram_id) }

    it { should validate_numericality_of(:words_count).is_less_than_or_equal_to(6) }
    it { should validate_numericality_of(:words_count).is_greater_than_or_equal_to(1) }
  end

  describe 'Association' do
    it { should have_many(:definitions).through(:learned_words) }
    it { should have_many(:learned_words).dependent(:destroy) }
  end

  describe 'Methods' do
    let(:schedule_count) { 3 }

    describe '#add_schedule' do
      let(:user) { create(:user, status: 'registered') }

      before { Timecop.freeze(2021, 4, 20, 22) }

      it 'adds schedule to user' do
        user.add_schedule(schedule_count)

        expect(User.find(user.id)).to have_attributes(
          status: 'scheduled',
          words_count: 3
        )
      end
    end

    describe '#receive_definition!' do
      let(:user) { create(:user, status: 'scheduled', words_count: schedule_count) }
      let(:definition) { create(:definition) }

      it 'adds word to already sent' do
        expect { user.receive_definition!(definition) }.to change(LearnedWord, :count).from(0).to(1)
      end

      it 'updates user' do
        user.receive_definition!(definition)

        expect(User.find(user.id)).to have_state(:waiting)
        expect(user.learned_words.first.id).to eq user.id
      end
    end

    describe '#upcoming_time_equal?' do
      let(:user) { create(:user, status: 'scheduled', words_count: schedule_count) }

      context 'when actual time equal to schedule time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 21).hour }

        it 'returns true' do
          expect(user).to be_upcoming_time_equal(time)
        end
      end

      context 'when actual time not equal to schedule time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'returns false' do
          expect(user).not_to be_upcoming_time_equal(time)
        end
      end
    end

    describe '#miss_time?' do
      let(:user) { create(:user, status: 'waiting', words_count: schedule_count) }

      context 'when actual time equal missed time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 17).hour }

        it 'returns true' do
          expect(user).to be_miss_time(time)
        end
      end

      context 'when actual time not equal missed time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'returns false' do
          expect(user).not_to be_miss_time(time)
        end
      end
    end
  end

  describe 'AASM' do
    let(:user) { build(:user) }

    it 'transitions look good' do
      expect(user).to transition_from(:new).to(:registered).on_event(:register)
      expect(user).to transition_from(:registered).to(:scheduled).on_event(:init_schedule)
      expect(user).to transition_from(:scheduled).to(:waiting).on_event(:get_word)
      expect(user).to transition_from(:waiting).to(:scheduled).on_event(:learn_word)
    end
  end
end
