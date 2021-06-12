# frozen_string_literal: true

require 'multi_json'

# Json parser
module JsonParser
  def load(request_body)
    request_body.rewind
    body = request_body.read

    MultiJson.load(body)
  end

  def hash_to_struct(hash)
    OpenStruct.new(hash.transform_values do |val|
                     val.is_a?(Hash) ? hash_to_struct(val) : val
                   end)
  end
end
