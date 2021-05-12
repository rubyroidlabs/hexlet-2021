# frozen_string_literal: true

env :PATH, ENV['PATH']

set :job_template, nil

# # every 30 minutes from 12 to 23
# every '*/30 12-23 * * *' do
#  rake 'app:send'
#  rake 'app:remind'
# end

# every minute from 12 to 23
every '*/1 12-23 * * *' do
  rake 'app:send'
  rake 'app:remind'
end
