require_relative '../lib/json_parser'
require_relative '../lib/request_transformer'

p JsonParser.new('https://test-users-2020.herokuapp.com/api/users') #, 'abc123')
