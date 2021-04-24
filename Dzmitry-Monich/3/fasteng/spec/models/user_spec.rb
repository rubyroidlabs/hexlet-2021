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
end
