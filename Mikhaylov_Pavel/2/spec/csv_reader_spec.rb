# frozen_string_literal: true

require_relative '../lib/checker/csv_reader'

describe CsvReader do
  let(:reader_source) { CsvReader.new('test.csv') }
  let(:reader_os) { CsvReader.new('os.csv') }

  it 'should correct load csv file and return data' do
    expect(reader_source.data).to be_an(Array)
    expect(reader_os.data.size).to eq(99)
  end
end
