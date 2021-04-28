# frozen_string_literal: true

require 'pathname'
require 'fasteng'

describe Fasteng::DictionaryCreator do
  let(:filepath) { File.expand_path('../fixtures', __dir__) }

  before do
    allow(Fasteng)
      .to receive(:root_path).and_return(Pathname.new(filepath))
  end

  it 'data parsed correctly' do
    expected = [
      { word: 'Abandoned', description: 'adj. 1 deserted, forsaken. 2 unrestrained, profligate.' },
      { word: 'Abattoir', description: 'n. Slaughterhouse. [french abatre fell, as *abate]' }
    ]

    described_class.setup

    expect(Definition.all).to match_array(
      [have_attributes(expected.first),
       have_attributes(expected.last)]
    )
  end

  context 'whitout data in database' do
    it 'data saved correctly' do
      expect { described_class.setup }.to change(Definition, :count).from(0).to(2)
    end
  end

  context 'whith data in database' do
    it 'data not saved another time' do
      described_class.setup

      expect { described_class.setup }.not_to change(Definition, :count)
    end
  end
end
