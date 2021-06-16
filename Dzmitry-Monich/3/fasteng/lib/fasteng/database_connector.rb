# frozen_string_literal: true

require 'yaml'

module Fasteng
  module DatabaseConnector
    class << self
      def call
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
