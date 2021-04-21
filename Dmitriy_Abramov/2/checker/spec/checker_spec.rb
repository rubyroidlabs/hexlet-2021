# frozen_string_literal: true

require_relative '../lib/app'
require_relative 'helpers'

describe Checker do
  include Helpers

  before do
    stub_request(:any, ->(_uri) { 200 })
    stub_request(:get, 'ralphonrails.com').to_raise(StandardError)
    stub_request(:get, 'git.mnt.ee').to_return(body: 'its body!', status: 200)
    stub_request(:get, 'xulu.gitlab.com').to_return(status: 404)
  end

  describe 'invalid file' do
    it 'returns an error with unknown file' do
      expect { run_app(file: 'fail.csv') }.to raise_error
    end
  end

  describe 'valid file' do
    it 'runs in one thread' do
      app = run_app

      expect(app.requests[:success].size).to eq(9)
      expect(app.requests[:error].size).to eq(1)
      expect(app.requests[:failed].size).to eq(1)
    end

    it 'runs in parallel' do
      app = run_app(parallel: 5)

      expect(app.requests[:success].size).to eq(9)
    end

    describe 'exclude solutions' do
      it 'not excluding solutions from file' do
        run_app

        expect(WebMock).to have_requested(:get, 'xulu.gitlab.com')
      end

      it 'excludes solutions from file' do
        run_app(exclude_solutions: true)

        expect(WebMock).not_to have_requested(:get, 'xulu.gitlab.com')
      end
    end

    describe 'exclude subdomains' do
      it 'not excludes subdomains' do
        run_app

        expect(WebMock).to have_requested(:get, 'git.mnt.ee')
      end

      it 'excludes subdomains' do
        run_app(no_subdomains: true)

        expect(WebMock).not_to have_requested(:get, 'git.mnt.ee')
      end
    end

    it 'filtering' do
      app = run_app(filter: 'body')

      expect(app.requests[:success].size).to eq(1)
    end
  end
end
