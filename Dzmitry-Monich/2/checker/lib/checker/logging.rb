# frozen_string_literal: true

require 'logger'

# Just a logger
module Logging
  def self.logger
    @logger ||= Logger.new(
      $stdout,
      formatter: proc { |sev, dtime, _, msg| "#{sev}, #{dtime}, #{msg}\n" }
    )
  end

  def logger
    Logging.logger
  end
end
