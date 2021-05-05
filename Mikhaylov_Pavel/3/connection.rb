# frozen_string_literal: true

require 'active_record'
require 'pg'
require 'logger'

ActiveRecord::Base.logger = Logger.new($stdout)

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  username: 'pavelmikhaylov',
  database: 'telegram_eng_bot'
)
