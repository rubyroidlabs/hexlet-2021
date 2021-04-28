# frozen_string_literal: true

require 'rspec'

require_relative '../lib/args_parser'

RSpec.describe ArgsParser do
  subject { described_class.parse(args) }
  let(:args) { %w[-n test_out.csv] }

  it 'parses with :subdomains arg' do
    expect(subject).to eq Hash[:subdomains, false]
  end

  context ':opensource' do
    let(:args) { %w[-r test_out.csv] }
    it 'parses with  :opensource arg' do
      expect(subject).to eq Hash[:opensource, true]
    end
  end

  context ':parallel' do
    let(:args) { %w[-p=3 test_out.csv] }
    it 'parses with  :parallel arg' do
      expect(subject).to eq Hash[:parallel, '=3']
    end
  end

  context 'KEYWORD' do
    let(:args) { %w[-f=KEYWORD test_out.csv] }
    it 'parses with :filter KEYWORD' do
      expect(subject).to eq Hash[:filter, '=KEYWORD']
    end
  end
end
