# frozen_string_literal: true

require_relative '../lib/checker/csv_reader'

describe CsvReader do
  let(:reader_source) { CsvReader.new('test.csv') }
  let(:reader_os) { CsvReader.new('os.csv') }
  let(:empty_csv) { CsvReader.new(File.join(__dir__, 'fixtures', 'empty.csv')) }

  it 'should correct load csv file and return data' do
    expect(reader_source.data).to be_an(Array)
    expect(reader_os.data.size).to eq(99)
  end

  it 'should raise exception' do
    expect { empty_csv.data }.to raise_error(StandardError, 'File is empty')
  end
end
