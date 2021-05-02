# frozen_string_literal: true

require 'fasteng'

describe Fasteng::App do
  before do
    allow(Fasteng::DatabaseConnector).to receive(:call)
    allow(Fasteng::DictionaryManager::DictionaryCreator).to receive(:call)
    allow(ENV).to receive(:[]).with('BOT_TOKEN').and_return('123456')
  end

  context 'when configered (by default) webhook request' do
    it 'App run WebhookController' do
      expect(Fasteng::WebhookController).to receive(:run)

      described_class.run
    end
  end

  context 'when configered long-polling request' do
    it 'App run PollingController' do
      Fasteng.config.controller = 'polling'

      expect(Fasteng::PollingController).to receive(:run)

      described_class.run
    end
  end
end
