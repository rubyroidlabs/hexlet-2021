# frozen_string_literal: true

require_relative '../notify_handler'

namespace :payload do
  desc 'Send out lesson messages'
  task send_messages: :environment do
    NotifyHandler.perform
  end
end
