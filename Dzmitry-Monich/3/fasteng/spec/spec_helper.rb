# frozen_string_literal: true

require 'shoulda/matchers'
require 'factory_bot'
require 'database_cleaner/active_record'
require 'fasteng'
require 'whenever/test'
require 'timecop'
require 'faker'

Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }

env = 'test'
configuration = YAML.load_file(Fasteng.root_path.join('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration[env])
load Fasteng.root_path.join('db/schema.rb')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryBot::Syntax::Methods
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    FactoryBot.find_definitions
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end
