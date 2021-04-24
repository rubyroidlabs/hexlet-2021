# frozen_string_literal: true

describe Definition, type: :model do
  describe 'Validate uniquness' do
    before { create(:definition) }

    it { should validate_uniqueness_of(:word) }
  end

  describe 'Validation presence' do
    context 'with not valid' do
      before { record.validate }

      context 'word' do
        let(:record) { build(:definition, word: '') }

        it 'is no valid' do
          expect(record.errors[:word]).to include("can't be blank")
        end
      end

      context 'description' do
        let(:record) { build(:definition, description: '') }

        it 'is no valid' do
          expect(record.errors[:description]).to include("can't be blank")
        end
      end
    end

    context 'when is valid' do
      let(:record) { build(:definition) }

      it 'word and description' do
        expect(record).to be_valid
      end
    end
  end
end
