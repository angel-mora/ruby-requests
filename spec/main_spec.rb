require 'rspec'
require_relative '../bin/main'

describe JsonParser do
  describe '#initialize' do
    it 'returns Hello world' do
      parser = JsonParser.new
      expect(parser).to eql('Hello world!')
    end
  end
end
