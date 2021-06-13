# frozen_string_literal: true

require_relative '../../app/services/telegram/lesson'
require_relative '../../app/models/user'

namespace :telegram do
  desc 'Start new training day'
  task :start_new_training_day do
    User.update_all(aasm_state: 'learning')
  end

  desc 'Start a lesson with a user'
  task :start_lesson do
    User.where(aasm_state: 'learning').each { |user| Telegram::Lesson.new(user).call }
  end

  desc 'Reminder for answer to user'
  task :reminder_for_answer do
    User.where(aasm_state: 'waiting_smiley').each { |user| Telegram::Reminder.new(user).call }
  end
end
