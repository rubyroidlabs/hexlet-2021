# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require_relative '../lib/generator'

RSpec.describe Generator do
  before do
    allow(Generator).to receive(:generate_word).and_return(:definition)
  end

  it 'stubbed when calling Generator' do
    expect(Generator.generate_word).to eq :definition
  end
end
