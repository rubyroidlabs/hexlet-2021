# frozen_string_literal: true

require_relative '../cron_worker'

namespace :payload do
  desc 'Send out lesson messages'
  task send_messages: :environment do
    CronWorker.perform
  end
end
