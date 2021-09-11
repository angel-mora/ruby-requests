require 'net/http'
require 'httparty'

# Handles GET request
class JsonParser
  attr_accessor :parsed_json

  def initialize(uri, auth)
    @parsed_json = get_from_uri(uri, auth)
  end

  private

  def get_from_uri(uri, auth)
    HTTParty.get(uri, headers: { Authorization: auth })
  end
end
