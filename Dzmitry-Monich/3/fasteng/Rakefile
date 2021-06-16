# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Rails/RakeEnvironment

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

require_relative 'lib/fasteng'

namespace :cron do
  task :notify do
    Fasteng::NotifyHandler.call
  end
end

# rubocop:enable Rails/RakeEnvironment
# rubocop:enable Lint/RedundantCopDisableDirective
