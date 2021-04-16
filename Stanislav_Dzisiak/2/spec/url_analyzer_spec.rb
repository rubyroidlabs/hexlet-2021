# frozen_string_literal: true

require_relative '../lib/url_analyzer/version'

RSpec.describe UrlAnalyzer do
  it 'has a version number' do
    expect(UrlAnalyzer::VERSION).not_to be nil
  end
end
