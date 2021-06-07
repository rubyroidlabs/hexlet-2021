# frozen_string_literal: true

require 'active_record'
require 'yaml'

ActiveRecord::Base.logger = Logger.new($stdout)

connection_details = YAML.load_file('./config/config.yml')['development']
ActiveRecord::Base.establish_connection(connection_details)
