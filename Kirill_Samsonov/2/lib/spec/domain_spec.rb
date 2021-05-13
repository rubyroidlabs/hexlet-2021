# frozen_string_literal: true

require_relative '../domain'

describe Domain do
  subject { Domain.new(name) }

  describe 'first level' do
    let(:name) { 'domain.com' }

    it 'is not subdomain' do
      expect(subject.subdomain?).to be false
    end
  end

  describe 'subdomain' do
    let(:name) { 'sub.domain.com' }

    it 'is subdomain' do
      expect(subject.subdomain?).to be true
    end
  end
end