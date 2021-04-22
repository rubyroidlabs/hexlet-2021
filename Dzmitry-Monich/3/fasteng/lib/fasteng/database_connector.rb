# frozen_string_literal: true

require 'logger'

class DatabaseConnector
  class << self
    def sync
      ActiveRecord::Base.logger = Logger.new('log/db.log')
      setup
    end

    private

    def setup
      env = ENV['DB_ENV'] || 'development'
      config = YAML.load_file(Fasteng.root_path.join('db/config.yml'))
      ActiveRecord::Base.establish_connection(config[env])
    end
  end
end
