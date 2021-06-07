# frozen_string_literal: true

RSpec.describe ParseCSV do
  subject { Class.new { extend ParseCSV } }
  describe '#parse_csv' do
    let(:filepath) { 'spec/fixtures/rails.csv' }
    let(:expected) do
      ['github.com', 'gitlab.com', 'agentcash.com', 'loneatnight.vhx.tv', 'yandex.ru', 'abfdsfsf.vsd.com']
    end
    it 'read data and return parsed csv' do
      expect(subject.parse_csv(filepath)).to eq expected
    end
  end
end
