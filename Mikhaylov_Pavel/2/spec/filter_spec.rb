# frozen_string_literal: true

require_relative '../lib/checker/filter'

describe Filter do
  subject(:urls) { CsvReader.new(File.join(__dir__, 'fixtures', 'example.csv')).data }
  subject(:options_with_os) { { solutions: true } }
  subject(:options_with_subdomains) { { subdomains: true } }
  subject(:options) { { solutions: true, subdomains: true } }

  describe '#apply_filter' do
    context 'with filter by open source' do
      let(:filter) { Filter.new(urls, options_with_os) }

      it 'should reduce the number of links' do
        expect(filter.apply_filter.size).to_not eq(urls.size)
      end
    end

    context 'with filter subdomains' do
      let(:filter) { Filter.new(urls, options_with_subdomains) }

      it 'should reduce the number of links' do
        expect(filter.apply_filter.size).to_not eq(urls.size)
        expect(filter.apply_filter).to_not include('alexandraiv.wixsite.com')
      end
    end

    context 'full filter options' do
      let(:filter) { Filter.new(urls, options) }

      it 'should remain 3 url' do
        expect(filter.apply_filter).to eq(%w[hexlet.io vk.com rara.com])
      end
    end
  end
end
