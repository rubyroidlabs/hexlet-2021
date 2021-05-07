# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require_relative '../lib/json_parser'

RSpec.describe JsonParser do
  before do
    allow(JsonParser).to receive(:load).and_return('{
    "update_id": 210195582,
    "message": {
        "from": {
            "id": 46938363
		}
	}}')
  end

  it '#load' do
    expect(JsonParser.send(:load)).to eq '{
    "update_id": 210195582,
    "message": {
        "from": {
            "id": 46938363
		}
	}}'
  end
end
