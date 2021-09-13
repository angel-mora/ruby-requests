require 'spec_helper'
require_relative '../bin/main'
require 'byebug'

describe JsonTransformer do
  describe '#initialize' do
    it 'gets the json body' do
      file = File.read('./spec/transformable.json')
      json_data = JSON.parse(file)
      requested = JsonTransformer.new(json_data.to_json)
      expect(requested.json_body).to be_a_kind_of(Array)
    end
  end

  describe '#valid?' do
    it 'validates firstName'
    it 'validates lastName'
    it 'validates email or phone present' do
      # it 'considers both parenthesized and plain number'
    end
  end

  describe '#remove_duplicates' do
    it 'merges users with same first and last names'
  end

  describe '#set_properly' do
    it 'takes phone data one level up'
  end

  describe '#transform' do
    it 'executes json cleaning properly'
  end

  describe '#export' do
    it "can't export if no valid users"
    it 'exports properly'
  end
end
