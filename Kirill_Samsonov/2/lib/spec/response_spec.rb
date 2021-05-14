# frozen_string_literal: true

require_relative '../response'

describe Response do
  subject { Response.new(data, options) }

  describe 'without options' do
    let(:options) { {} }

    describe 'with success response' do
      let(:data) { instance_double('NetResponse', body: 'some body', code: '200') }

      it 'is not skipped' do
        expect(subject.skip?).to be false
      end

      it 'is success' do
        expect(subject.success?).to be true
      end
    end

    describe 'with error' do
      let(:data) { instance_double('NetResponse', body: 'some body', code: '500') }

      it 'is not skipped' do
        expect(subject.skip?).to be false
      end

      it 'is not success' do
        expect(subject.success?).to be false
      end
    end
  end

  describe 'with filter option' do
    let(:options) { { filter: 'target' } }

    describe 'has match' do
      let(:data) { instance_double('NetResponse', body: 'body with target', code: '200') }

      it 'not skipping' do
        expect(subject.skip?).to be false
      end
    end

    describe 'has no match' do
      let(:data) { instance_double('NetResponse', body: 'body', code: '200') }

      it 'is skipped' do
        expect(subject.skip?).to be true
      end
    end
  end

  describe 'with exclude solution option' do
    let(:options) { { exclude_solutions: true } }

    describe 'and open source match' do
      let(:data) { instance_double('NetResponse', body: 'has open source', code: '200') }

      it 'is skipped' do
        expect(subject.skip?).to be true
      end
    end

    describe 'and not open source' do
      let(:data) { instance_double('NetResponse', body: 'just something', code: '200') }

      it 'is not skipped' do
        expect(subject.skip?).to be false
      end
    end
  end
end
