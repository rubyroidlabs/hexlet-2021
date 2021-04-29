# frozen_string_literal: true

require 'pathname'
require 'fasteng'

describe Fasteng::DictionaryManager do
  let(:filepath) { File.expand_path('../fixtures', __dir__) }

  before do
    allow(Fasteng)
      .to receive(:root_path).and_return(Pathname.new(filepath))
  end

  describe 'Creation dictionary' do
    it 'data parsed correctly' do
      expected = [
        { word: 'Abandoned', description: 'adj. 1 deserted, forsaken. 2 unrestrained, profligate.' },
        { word: 'Abattoir', description: 'n. Slaughterhouse. [french abatre fell, as *abate]' }
      ]

      described_class::DictionaryCreator.setup

      expect(Definition.all).to match_array(
        [have_attributes(expected.first), have_attributes(expected.last)]
      )
    end

    context 'whitout data in database' do
      it 'data saved correctly' do
        expect { described_class::DictionaryCreator.setup }.to change(Definition, :count).from(0).to(2)
      end
    end

    context 'whith data in database' do
      it 'data not saved another time' do
        described_class::DictionaryCreator.setup

        expect { described_class::DictionaryCreator.setup }.not_to change(Definition, :count)
      end
    end
  end

  describe 'Select word' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:definition) { create(:definition) }

    before { LearnedWord.create({ user: user1, definition: definition }) }

    context 'when already learned' do
      it 'word not selected' do
        word = described_class::DictionarySelector.select_word(user1)

        expect(word).to be_nil
      end
    end

    context 'when not learned' do
      it 'word selected' do
        word = described_class::DictionarySelector.select_word(user2)

        expect(word).to eq definition
      end
    end
  end
end
