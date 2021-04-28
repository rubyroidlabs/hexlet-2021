# frozen_string_literal: true

module Fasteng
  module DatabaseConnector
    class << self
      def sync
        ActiveRecord::Base.logger = Logger.new($stdout)
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
end
