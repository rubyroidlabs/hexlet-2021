# frozen_string_literal: true

require 'sinatra/activerecord'
require 'dotenv'

Dotenv.load

set :database, {
  adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  username: ENV['DATABASE_USER'],
  password: ENV['DATABASE_PASSWORD'],
  database: ENV['DATABASE_NAME']
}
