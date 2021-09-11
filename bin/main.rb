require_relative '../lib/json_parser'
require_relative '../lib/json_transformer'

request = JsonParser.new('https://test-users-2020.herokuapp.com/api/users', 'abc123').parsed_json.body
JsonTransformer.new(request)
