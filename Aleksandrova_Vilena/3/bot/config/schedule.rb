# frozen_string_literal: true

require_relative '../lib/cron_worker'

set :environment, 'development'
set :output, 'log/cron.log'

# prod
# every '0 10-19/1 * * 1-5' do
#  rake 'payload:send_messages'
# end

# dev testing
every '*/3 * * * 1-5' do
  rake 'payload:send_messages'
end
