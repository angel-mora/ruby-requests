require 'spec_helper'
require_relative '../bin/main'

describe JsonParser do
  describe '#initialize' do
    it "doesn't reads provided URI" do
      # stub_request(:get, 'https://test-users-2020.herokuapp.com/api/users').to_return("{\"error\":\"There doesn't seem to be an Authorization token in the headers, try setting it to 'abc123'\"}")
      #json_body = JsonParser.new('https://test-users-2020.herokuapp.com/api/users')
      #expect(json_body).to eql "{\"error\":\"There doesn't seem to be an Authorization token in the headers, try setting it to 'abc123'\"}"
    end
  end
end
