# frozen_string_literal: true

require 'url_analyzer'
require 'vcr'
require 'webmock/rspec'

def get_fixture_path(fixture_name)
  File.join(__dir__, 'fixtures', fixture_name)
end

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into(:webmock)
end
