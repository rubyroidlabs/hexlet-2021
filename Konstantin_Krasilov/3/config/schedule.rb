# frozen_string_literal: true

set :output, 'log/cron.log'

every '00 00 * * *' do
  rake 'telegram:start_new_training_day'
end

every '00 11-22 * * *' do
  rake 'telegram:start_lesson'
end

every '*/5 * * * *' do
  rake 'telegram:reminder_for_answer'
end
