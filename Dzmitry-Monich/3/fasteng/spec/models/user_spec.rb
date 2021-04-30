# frozen_string_literal: true

describe User, type: :model do
  describe 'Validate uniquness' do
    before { create(:user) }

    it { should validate_uniqueness_of(:telegram_id).case_insensitive }
  end

  describe 'Associacion' do
    it { should have_many(:definitions).through(:learned_words) }
    it { should have_many(:learned_words).dependent(:destroy) }
  end

  describe 'Validation presence' do
    context 'whith not valid' do
      let(:user) { build(:user, telegram_id: '') }

      it 'telegram_id is not valid' do
        user.validate
        expect(user.errors[:telegram_id]).to include("can't be blank")
      end
    end

    context 'with valid' do
      let(:user) { build(:user) }

      it 'telegram_id is valid' do
        expect(user).to be_valid
      end
    end
  end

  describe 'Methods' do
    describe '#add_schedule!' do
      let(:user) { create(:user, status: 'registered') }
      let(:schedule_count) { 3 }

      before { Timecop.freeze(2021, 4, 20, 22) }

      it 'adds schedule to user' do
        user.add_schedule!(schedule_count)

        expect(User.find(user.id)).to have_attributes(
          status: 'scheduled',
          schedule: '9,15,21',
          upcoming_time: 9
        )
      end
    end

    describe '#receive_definition!' do
      let(:user) { create(:user, status: 'scheduled', schedule: '9,15,21', upcoming_time: 21) }
      let(:definition) { create(:definition) }

      it 'adds word to already sent' do
        expect { user.receive_definition!(definition) }.to change(LearnedWord, :count).from(0).to(1)
      end

      it 'updates user' do
        user.receive_definition!(definition)

        expect(User.find(user.id)).to have_attributes(
          status: 'waiting',
          upcoming_time: 9
        )
        expect(user.learned_words.first.id).to eq user.id
      end
    end

    describe '#upcoming_time_equal?' do
      let(:user) { create(:user, status: 'scheduled', schedule: '9,15,21', upcoming_time: 21) }

      context 'when actual time equal to schedule time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 21).hour }

        it 'returns true' do
          expect(user.upcoming_time_equal?(time)).to be true
        end
      end

      context 'when actual time not equal to schedule time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'returns false' do
          expect(user.upcoming_time_equal?(time)).to be false
        end
      end
    end

    describe '#miss_time?' do
      let(:user) { create(:user, status: 'waiting', schedule: '9,15,21', upcoming_time: 21) }

      context 'when actual time equal missed time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 17).hour }

        it 'returns true' do
          expect(user.miss_time?(time)).to be true
        end
      end

      context 'when actual time not equal missed time' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'returns false' do
          expect(user.miss_time?(time)).to be false
        end
      end
    end
  end
end
