require 'csv_reader'
require 'csv'

describe CSVReader do
  let(:reader) { CSVReader.new(File.join(__dir__, 'fixtures', 'data.csv')) }

  it 'should correctly assign variable' do
    expect(reader.csv_rows).to be_an(Array)
    expect(reader.csv_rows.size).to eq 5
    expect(reader.csv_rows).to match_array %w[google.com
                                              linux.org
                                              opennet.ru
                                              bbc.com
                                              ru.wikipedia.org]
  end

  describe '#filter_by_domains' do
    it 'should filter by domains' do
      expect(reader.filter_by_domains).to match_array %w[google.com
                                                         linux.org
                                                         opennet.ru
                                                         bbc.com]
      expect(reader.filter_by_domains.size).to eq 4
    end
  end

  describe '#filter_by_opensourse' do
    it 'should filter by opensourse data' do
      os_data = File.join(__dir__, 'fixtures', 'os.csv')
      expect(reader.filter_by_opensourse(os_data)).to match_array ['linux.org']
      expect(reader.filter_by_opensourse(os_data).size).to eq 1
    end
  end
end
