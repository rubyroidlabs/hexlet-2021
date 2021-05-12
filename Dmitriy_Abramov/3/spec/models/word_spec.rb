# frozen_string_literal: true

describe Word, type: :model do
  describe 'associations' do
    it { should have_many(:learned_words).dependent(:destroy) }
    # it { should have_many(:users).through(:learned_words) }
  end

  describe 'validations' do
    describe 'value' do
      context 'uniqueness' do
        before { create(:word) }

        it { should validate_uniqueness_of(:value) }
      end

      context 'presence' do
        let(:word) { build(:word, value: nil) }

        it { expect(subject).not_to be_valid }
      end
    end

    describe 'description' do
      context 'presence' do
        let(:word) { build(:word, description: nil) }

        it { expect(subject).not_to be_valid }
      end
    end
  end
end
