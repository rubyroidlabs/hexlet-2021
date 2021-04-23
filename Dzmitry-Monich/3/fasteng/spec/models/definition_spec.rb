# frozen_string_literal: true

describe Definition, type: :model do
  describe 'Validation' do
    describe 'Uniquness' do
      before { create(:definition) }

      it { should validate_uniqueness_of(:word) }
    end

    describe 'Presence' do
      context 'when is not valid' do
        let(:invalid_word) { build(:definition, word: '') }
        let(:invalid_description) { build(:definition, description: '') }

        it 'word' do
          invalid_word.validate
          expect(invalid_word.errors[:word]).to include("can't be blank")
        end

        it 'description' do
          invalid_description.validate
          expect(invalid_description.errors[:description]).to include("can't be blank")
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
end
