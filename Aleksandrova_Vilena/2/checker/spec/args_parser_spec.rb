# frozen_string_literal: true

require 'rspec'

require_relative '../lib/helper'

RSpec.describe 'ArgsParser: --subdomains' do
  # let(:exec) { File.expand_path('../checker.rb', File.dirname(__FILE__)) }
  subject { ArgsParser.parse(args) }
  let(:args) { %w[-n test_out.csv] }

  it ':subdomains' do
    expect(subject).to eq Hash[:subdomains, false]
  end
end

RSpec.describe 'ArgsParser: --opensource' do
  subject { ArgsParser.parse(args) }
  let(:args) { %w[-r test_out.csv] }
  it ':opensource' do
    expect(subject).to eq Hash[:opensource, true]
  end
end

RSpec.describe 'ArgsParser: --parallel' do
  subject { ArgsParser.parse(args) }
  let(:args) { %w[-p=3 test_out.csv] }
  it ':parallel' do
    expect(subject).to eq Hash[:parallel, '=3']
  end
end

RSpec.describe 'ArgsParser: --filter' do
  subject { ArgsParser.parse(args) }
  let(:args) { %w[-f=KEYWORD test_out.csv] }
  it ':parallel' do
    expect(subject).to eq Hash[:filter, '=KEYWORD']
  end
end
