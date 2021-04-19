# frozen_string_literal: true

require 'link'

describe Link do
  let(:link) { described_class.new('dippl.org') }

  describe '.new' do
    it 'creates new object with given uri and valid' do
      expect(link.uri).to be_an(URI)
      expect(link.valid).to be true
    end
  end

  describe '#valid?' do
    context 'when are valid' do
      it 'returns true' do
        expect(link.valid?).to be true
      end
    end

    context 'when are not valid' do
      before { link.valid = false }

      it 'returns false' do
        expect(link.valid?).to be false
      end
    end
  end

  describe '#status?' do
    context 'when link are errored?' do
      before { link.error = 'ERROR (getaddrinfo: nodename nor servname provided, or not known)' }

      it 'returns errored' do
        expect(link.status).to eq(:errored)
      end
    end

    context 'when link are success??' do
      before { link.code = 200 }

      it 'returns success' do
        expect(link.status).to eq(:success)
      end
    end

    context 'when link are failed?' do
      before { link.code = 400 }

      it 'returns failed' do
        expect(link.status).to eq(:failed)
      end
    end
  end
end
