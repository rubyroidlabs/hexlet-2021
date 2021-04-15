# frozen_string_literal: true

##
class Response
  attr_accessor :uri, :code, :msg, :time, :is_err, :keyword

  def initialize(param)
    @uri = param[:uri]
    @code = param[:code]
    @msg = param[:message]
    @time = param[:time]
    @is_err = param[:is_err]
    @keyword = param[:keyword]
  end

  # @return [TrueClass, FalseClass]
  def success?
    @code == 200
  end

  # @return [TrueClass, FalseClass]
  def fail?
    @code != 200 && !@is_err
  end

  def error?
    @is_err
  end

  def to_s
    return "#{@uri} - ERROR (#{@msg})" if error?
    return "#{@uri} - #{@code}, #{@msg} (#{@time}ms)" if msg.equal?('OK')

    "#{@uri} - #{@code} (#{@time}ms)"
  end
end
