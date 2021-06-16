# frozen_string_literal: true

describe Definition, type: :model do
  describe 'Validation' do
    before { create(:definition) }

    it { should validate_uniqueness_of(:word) }
    it { should validate_presence_of(:word) }
    it { should validate_presence_of(:description) }
  end

  describe 'Association' do
    it { should have_many(:users).through(:learned_words) }
    it { should have_many(:learned_words).dependent(:destroy) }
  end
end
