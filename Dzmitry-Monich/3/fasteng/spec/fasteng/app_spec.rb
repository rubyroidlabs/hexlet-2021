# frozen_string_literal: true

describe Fasteng::App do
  before do
    allow(Fasteng::DatabaseConnector).to receive(:call)
    allow(Fasteng::DictionaryManager::DictionaryCreator).to receive(:call)
    allow(ENV).to receive(:[]).with('BOT_TOKEN').and_return('123456')
  end

  context 'when configered (by default) long-polling request' do
    it 'App run PollingController' do
      expect(Fasteng::PollingController).to receive(:run)

      described_class.run
    end
  end

  context 'when configered webhook request' do
    before { Fasteng.config.controller = 'webhook' }

    it 'App does not run WebhookController because url not passed' do
      expect { described_class.run }
        .to raise_error(ArgumentError, 'no url for webhook controller')
    end

    it 'App run WebhookController' do
      Fasteng.config.url = 'http://webhook'

      expect(Fasteng::WebhookController).to receive(:run)

      described_class.run
    end
  end
end
