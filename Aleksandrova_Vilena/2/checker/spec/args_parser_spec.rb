# frozen_string_literal: true

require 'rspec'

require_relative '../lib/helper'

RSpec.describe ArgsParser do
  subject { described_class.parse(args) }
  let(:args) { %w[-n test_out.csv] }

  it ':subdomains' do
    expect(subject).to eq Hash[:subdomains, false]
  end
end

RSpec.describe ArgsParser do
  subject { described_class.parse(args) }
  let(:args) { %w[-r test_out.csv] }
  it ':opensource' do
    expect(subject).to eq Hash[:opensource, true]
  end
end

RSpec.describe ArgsParser do
  subject { described_class.parse(args) }
  let(:args) { %w[-p=3 test_out.csv] }
  it ':parallel' do
    expect(subject).to eq Hash[:parallel, '=3']
  end
end

RSpec.describe ArgsParser do
  subject { described_class.parse(args) }
  let(:args) { %w[-f=KEYWORD test_out.csv] }
  it ':filter KEYWORD' do
    expect(subject).to eq Hash[:filter, '=KEYWORD']
  end
end
