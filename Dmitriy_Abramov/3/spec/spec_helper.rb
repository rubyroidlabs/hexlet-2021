# frozen_string_literal: true

require 'shoulda/matchers'
require 'factory_bot'
require 'faker'
require 'aasm/rspec'
require 'database_cleaner/active_record'

connection_details = YAML.load_file('./config/config.yml')['test']
ActiveRecord::Base.establish_connection(connection_details)
Dir['./models/*.rb'].each { |model| require model }
load './db/schema.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end
