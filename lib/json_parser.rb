require 'net/http'
require 'httparty'

# Handles GET request
class JsonParser
  attr_accessor :json_body

  def initialize(uri)
    @json_body = get_body_from_uri(uri)
  end

  private

  def get_body_from_uri(uri)
    HTTParty.get(uri,
                 headers: {
                   Authorization: 'abc123'
                 }).body
  end
end
