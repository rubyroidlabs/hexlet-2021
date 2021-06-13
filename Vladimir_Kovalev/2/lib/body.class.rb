class Body
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def match_keyword?(keyword)
    !@body.scan(/#{keyword}/).empty?
  end
end
