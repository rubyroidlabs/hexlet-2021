# frozen_string_literal: true

require 'link'
require 'reader'

describe Reader do
  describe '.from_csv' do
    context 'when options key exists exclude solutions' do
      it 'links without links solutions' do
        links = described_class.from_csv(File.join(__dir__, 'fixtures', 'rails.csv'), { solutions: true })

        expect(links.size).to eq(4)
      end
    end

    context 'when options key exists subdomains' do
      it 'links without links subdomains' do
        links = described_class.from_csv(File.join(__dir__, 'fixtures', 'rails.csv'), { subdomains: true })

        expect(links.size).to eq(3)
      end
    end

    context 'when options key exists subdomains and solutions' do
      it 'links without links subdomains and solutions' do
        links =
          described_class.from_csv(File.join(__dir__, 'fixtures', 'rails.csv'), { subdomains: true, solutions: true })

        expect(links.size).to eq(3)
      end
    end

    context 'when options empty' do
      it 'return all links ' do
        links = described_class.from_csv(File.join(__dir__, 'fixtures', 'rails.csv'))

        expect(links.size).to eq(6)
      end
    end

    context 'what returns' do
      it 'return array from link elements' do
        links = described_class.from_csv(File.join(__dir__, 'fixtures', 'rails.csv'))

        expect(links).to be_an(Array)
        expect(links).to all be_a(Link)
      end
    end
  end
end
