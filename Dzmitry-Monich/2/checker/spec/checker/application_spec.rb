require 'checker'

describe Checker::Application do
  describe 'parse csv' do
    let(:filepath) { 'spec/fixtures/rails.csv' }

    context 'correctly' do
      it 'without filter' do
        test_path = File.expand_path('../fixtures/rails.csv', __dir__)

        expected = CSV.read(test_path).flatten
        expect(subject.call(filepath)).to eq expected
      end

      # it 'with subdomains filter' do
      #   checker = Checker::Application.new({ no_subdomains: true })
      #   test_path = File.expand_path('../fixtures/rails_subdomains.csv', __dir__)

      #   expected = CSV.read(test_path).flatten
      #   expect(checker.call(filepath)).to eq expected
      # end

      # it 'with subdomains filter' do
      #   checker = Checker::Application.new({ exclude_solutions: true })
      #   test_path = File.expand_path('../fixtures/rails_constrains.csv', __dir__)

      #   expected = CSV.read(test_path).flatten
      #   expect(checker.call(filepath)).to eq expected
      # end

      # it 'with all filters' do
      #   checker = Checker::Application.new(
      #     {
      #       no_subdomains: true,
      #       exclude_solutions: true
      #     }
      #   )
      #   test_path = File.expand_path('../fixtures/rails_all_filters.csv', __dir__)

      #   expected = CSV.read(test_path).flatten
      #   expect(checker.call(filepath)).to eq expected
      # end
    end

    context 'with errors' do
      it 'wrong filepath' do
        no_file_path = 'spec/fixtures/rai.csv'
        expect { subject.call(no_file_path) }
          .to raise_error(ArgumentError, 'no such a file')
      end

      it 'parser not exist' do
        no_parser_path = 'spec/fixtures/rails.json'
        expect { subject.call(no_parser_path) }
          .to raise_error('no such a parser')
      end
    end
  end
end
