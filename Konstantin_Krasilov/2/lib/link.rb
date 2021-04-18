# frozen_string_literal: true

require 'net/http'
# Link
class Link
  attr_accessor :uri, :code, :response_time, :error, :valid

  def initialize(uri)
    @uri = URI("http://#{uri}")
    @valid = true
  end

  def valid?
    @valid
  end

  def status
    return :errored if errored?
    return :success if success?

    :failed
  end

  private

  def success?
    (200...400).include?(@code)
  end

  def failed?
    (400...600).include?(@code)
  end

  def errored?
    @error
  end

  def to_s
    return "#{@uri.host} - #{@error}" if errored?

    "#{@uri.host} - #{@code} (#{@response_time}ms)"
  end
end
