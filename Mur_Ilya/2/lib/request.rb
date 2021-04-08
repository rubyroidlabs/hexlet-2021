class Request
  attr_reader :uri, :status, :time

  def initialize(args)
    @uri = args[:uri]
    @status = args[:status]
    @time = args[:time]
  end

  def to_s
    "#{uri} - #{status} #{time}"
  end

  def error?
    status.is_a?(String)
  end

  def fail?
    status.is_a?(Integer) && (status < 200 || status >= 400)
  end

  def success?
    status.is_a?(Integer) && (status >= 200 && status < 400)
  end
end
