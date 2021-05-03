# frozen_string_literal: true

set :output, 'log/cron.log'

every '0 10 * * 1-7' do
  rake 'telegram:start_lesson[6]'
end

every '0 12 * * 1-7' do
  rake 'telegram:start_lesson[5]'
end

every '0 14 * * 1-7' do
  rake 'telegram:start_lesson[4]'
end

every '0 16 * * 1-7' do
  rake 'telegram:start_lesson[3]'
end

every '0 18 * * 1-7' do
  rake 'telegram:start_lesson[2]'
end

every '0 20 * * 1-7' do
  rake 'telegram:start_lesson[1]'
end
