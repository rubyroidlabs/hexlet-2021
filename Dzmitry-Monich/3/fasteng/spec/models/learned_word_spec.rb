# frozen_string_literal: true

describe LearnedWord, type: :model do
  describe 'Associacion' do
    it { should belong_to(:user) }
    it { should belong_to(:definition) }
  end
end
