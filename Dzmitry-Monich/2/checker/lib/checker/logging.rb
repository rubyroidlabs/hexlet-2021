require 'logger'

module Logging
  def logger
    Logging.logger
  end

  def self.logger
    @logger ||= Logger.new(
      $stdout,
      formatter: proc { |sev, dtime, _, msg| "#{sev}, #{dtime}, #{msg}\n" }
    )
  end
end
