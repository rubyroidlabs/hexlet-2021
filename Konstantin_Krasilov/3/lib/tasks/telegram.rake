# frozen_string_literal: true

require_relative '../../app/services/telegram/lesson'
require_relative '../../app/models/user'

namespace :telegram do
  desc 'Start a lesson with a user'

  task :start_lesson, [:max_words] do |_, args|
    User.where(max_words: (1..args[:max_words].to_i)).each { |user| Telegram::Lesson.new(user).call }
  end
end
