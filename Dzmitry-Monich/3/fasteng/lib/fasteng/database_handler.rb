# frozen_string_literal: true

require 'logger'

module Fasteng
  module DatabaseHandler
    module_function

    def sync
      ActiveRecord::Base.logger = Logger.new('log/db.log')
      setup
    end

    def setup
      env = ENV['DB_ENV'] || 'development'
      config = YAML.load_file(Fasteng.root_path.join('db/config.yml'))
      ActiveRecord::Base.establish_connection(config[env])
    end
  end
end
