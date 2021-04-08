class RequestCollector
  attr_reader :requests

  def self.send_requests(resources, word = '')
    requests = []
    resources.each do |resource|
      begin
        start_time = Time.now
        response = HTTParty.get("http://#{resource}/", { timeout: 1 })
        next unless response.body.include?(word)

        status = response.code
        time_string = "(#{((Time.now - start_time) * 1000).round}ms)"
      rescue StandardError => e
        status = "ERROR (#{e})"
      end
      request = Request.new(uri: resource, status: status, time: time_string)
      requests << request
      print_out(request)
    end
    new(requests)
  end

  def self.print_out(request)
    puts request
  end

  def initialize(requests)
    @requests = requests
  end

  def summary
    "Total: #{@requests.size}, Success: #{successed}, Failed: #{failed}, Errored: #{errored}"
  end

  private

  def successed
    @requests.select(&:success?).size
  end

  def failed
    @requests.select(&:fail?).size
  end

  def errored
    @requests.select(&:error?).size
  end
end
