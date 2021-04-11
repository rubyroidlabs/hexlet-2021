# frozen_string_literal: true

##
class Response
  attr_reader :url, :code, :message, :time, :err

  def initialize(param)
    @url = param[:url]
    @code = param[:code]
    @message = param[:message]
    @time = param[:time]
    @err = param[:err]
  end

  # @return [TrueClass, FalseClass]
  def success?
    @code == 200
  end

  # @return [TrueClass, FalseClass]
  def fail?
    @code != 200 && !@err
  end

  def error?
    @err
  end

  def to_s
    return "#{@url} - ERROR (#{@message})" if error?
    return "#{@url} - #{@code}, #{@message} (#{@time}ms)" if message.equal?('OK')

    "#{@url} - #{@code} (#{@time}ms)"
  end
end
