# frozen_string_literal: true

require_relative '../lib/app'

describe Checker::App do
  before do
    stub_request(:any, ->(_uri) { 200 })
    stub_request(:get, 'ralphonrails.com').to_raise(StandardError)
    stub_request(:get, 'git.mnt.ee').to_return(body: 'its body!', status: 200)
    stub_request(:get, 'xulu.gitlab.com').to_return(status: 404)
  end

  context 'invalid file' do
    let(:file) { 'fail.csv' }

    subject { described_class.new({ file: file }) }

    it 'returns an error with unknown file' do
      expect { subject.run }.to raise_error
    end
  end

  context 'valid file' do
    let(:file) { 'test.csv' }

    context 'one thread' do
      subject { described_class.new({ file: file }) }

      before { subject.run }

      it 'runs in one thread' do
        expect(subject.requests[:success].size).to eq(9)
      end
    end

    context 'multi-thread' do
      subject { described_class.new({ file: file, parallel: parallel }) }
      let(:parallel) { 5 }
      before { subject.run }

      it 'runs in parallel' do
        expect(subject.requests[:success].size).to eq(9)
      end
    end

    context 'exclude solutions' do
      context 'without option' do
        subject { described_class.new({ file: file }) }
        before { subject.run }

        it 'not excluding solutions from file' do
          expect(WebMock).to have_requested(:get, 'xulu.gitlab.com')
        end
      end

      context 'with option' do
        subject { described_class.new({ file: file, exclude_solutions: true }) }
        before { subject.run }

        it 'excludes solutions from file' do
          expect(WebMock).not_to have_requested(:get, 'xulu.gitlab.com')
        end
      end
    end

    context 'exclude subdomains' do
      context 'without option' do
        subject { described_class.new({ file: file }) }
        before { subject.run }

        it 'not excludes subdomains' do
          expect(WebMock).to have_requested(:get, 'git.mnt.ee')
        end
      end

      context 'with option' do
        subject { described_class.new({ file: file, no_subdomains: true }) }
        before { subject.run }

        it 'excludes subdomains' do
          expect(WebMock).not_to have_requested(:get, 'git.mnt.ee')
        end
      end
    end
  end
end
