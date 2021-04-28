# frozen_string_literal: true

set :output, 'log/cron.log'

every '0 0-23 * * 0-6' do
  rake 'cron:notify'
end

# test
# every '0-59 * * * 0-6' do
#   rake 'cron:notify'
# end
