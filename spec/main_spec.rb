require 'byebug'
require 'spec_helper'
require_relative '../bin/main'

describe JsonParser do
  describe '#initialize' do
    it "doesn't reads provided URI unless header setup" do
      stub_request(:get, 'https://test-users-2020.herokuapp.com/api/users').to_return(status: 401)
      new_request = JsonParser.new('https://test-users-2020.herokuapp.com/api/users', '')
      expect(new_request.parsed_json.code).to eq(401)
    end

    it 'reads provided URI with auth header' do
      stub_request(:get, 'https://test-users-2020.herokuapp.com/api/users')
        .with(
          headers: {
            Authorization: 'abc123'
          }
        )
        .to_return(status: 200)
      authenticated = JsonParser.new('https://test-users-2020.herokuapp.com/api/users', 'abc123')
      expect(authenticated.parsed_json.code).to eq(200)
    end
  end
end
