# frozen_string_literal: true

require 'pathname'
require 'fasteng'

describe Fasteng::Dictionary do
  let(:filepath) { File.expand_path('../fixtures', __dir__) }

  before do
    allow(Fasteng)
      .to receive(:root_path).and_return(Pathname.new(filepath))
  end

  it 'parser works correctly' do
    expected = [
      { word: 'Abandoned', description: 'adj. 1 deserted, forsaken. 2 unrestrained, profligate.' },
      { word: 'Abattoir', description: 'n. Slaughterhouse. [french abatre fell, as *abate]' }
    ]

    expect(subject.definitions).to eq(expected)
  end
end
