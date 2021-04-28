# frozen_string_literal: true

describe User, type: :model do
  describe 'Validate uniquness' do
    before { create(:user) }

    it { should validate_uniqueness_of(:telegram_id) }
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

    describe '#notify!' do
      let(:user) { create(:user, status: 'scheduled', schedule: '9,15,21', upcoming_time: 21) }

      it 'updates user when notification' do
        user.notify!

        expect(User.find(user.id)).to have_attributes(
          status: 'waiting',
          upcoming_time: 9
        )
      end
    end

    describe '#upcoming_time_equal?' do
      let(:user) { create(:user, status: 'scheduled', schedule: '9,15,21', upcoming_time: 21) }

      context 'when notification time is correct' do
        let(:time) { Timecop.freeze(2021, 4, 20, 21).hour }

        it 'check is correct' do
          expect(user.upcoming_time_equal?(time)).to be true
        end
      end

      context 'when notification time is wrong' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'check failed' do
          expect(user.upcoming_time_equal?(time)).to be false
        end
      end
    end

    describe '#miss_time?' do
      let(:user) { create(:user, status: 'waiting', schedule: '9,15,21', upcoming_time: 21) }

      context 'when missed time interval correct' do
        let(:time) { Timecop.freeze(2021, 4, 20, 17).hour }

        it 'check is correct' do
          expect(user.miss_time?(time)).to be true
        end
      end

      context 'when missed time interval wrong' do
        let(:time) { Timecop.freeze(2021, 4, 20, 20).hour }

        it 'check failed' do
          expect(user.miss_time?(time)).to be false
        end
      end
    end
  end
end
