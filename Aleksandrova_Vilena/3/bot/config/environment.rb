# frozen_string_literal: true

require 'sinatra/activerecord'

ActiveRecord::Base.logger = Logger.new($stdout)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/learning.db'
  #adapter: 'postgresql',
  #host: 'localhost',
  #username: 'admin',
  #database: 'learning_development',
  #password: 1
)
