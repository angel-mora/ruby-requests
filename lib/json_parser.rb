require 'net/http'

# Handles GET request
class JsonParser
  attr_accessor :json_body

  def initialize(uri)
    @json_body = get_body_from_uri(uri)
  end

  private

  def get_body_from_uri(uri)
    Net::HTTP.get_response(URI.parse(uri)).body
  end
end
