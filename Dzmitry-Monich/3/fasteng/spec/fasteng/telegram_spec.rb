# frozen_string_literal: true

require 'fasteng'

describe Fasteng::App do
  let(:bot_client) { Telegram::Bot::Client }
  let(:token) { '123456' }
  let(:result) { double }

  before do
    allow(ENV)
      .to receive(:[]).with('BOT_TOKEN').and_return(token)
  end

  it 'telegram bot runs correctly' do
    expect(bot_client)
      .to receive(:run).with(token)

    subject.run
  end

  it 'bot-server gets handler' do
    expect_any_instance_of(bot_client)
      .to receive(:listen)

    subject.run
  end
end
