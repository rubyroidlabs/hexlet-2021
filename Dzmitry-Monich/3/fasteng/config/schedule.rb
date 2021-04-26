# frozen_string_literal: true

set :output, 'log/cron.log'

every :minute do
  rake 'cron:notify'
end

# every '* 0-23 * * 0-6' do
#   rake 'cron:notify'
# end

# every 1.minute do
#   rake 'cron:test'
# end
