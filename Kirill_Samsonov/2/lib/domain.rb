# frozen_string_literal: true

class Domain
  attr_reader :name, :elapsed_time

  def initialize(name)
    @name = name
    @elapsed_time = 0
  end

  def check
    start_time = Time.now.utc
    check_result = Net::HTTP.get_response(@name, '/')
    @elapsed_time = ((Time.now.utc - start_time) * 1000).round
    check_result
  end

  def subdomain?
    @name.count('.') > 1
  end
end
