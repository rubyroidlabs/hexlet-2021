# frozen_string_literal: true

RSpec.describe ParseCSV do
  subject { ParseCSV::parse_csv(filepath) }
  describe '#parse_csv' do
    let(:filepath) { 'spec/fixtures/rails.csv' } 
    let(:expected) { ["000010.industry-std.com", "github.com", "gitlab.com", "0s.m5sxiytpn52hg5dsmfyc4y3pnu.cmle.ru", "0s.o53xo.mjzg653tmvzhg5dbmnvs4y3pnu.nblz.ru", "1.sendvid.com", "1000albergues.com", "agentboca.com", "agentcash.com", "agenturoffice.sunzinet.com", "agilecockpitpspotrainthetrainer.doattend.com", "agilehumanities.ca", "agirlwalkshomealoneatnight.vhx.tv"] }
    it 'read data and return parsed csv' do
      expect(subject).to eq expected
    end
  end
end