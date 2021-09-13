require 'spec_helper'
require_relative '../bin/main'
require 'byebug'

describe JsonTransformer do
  let(:file) { File.read('./spec/transformable.json') }
  let(:json_data) { JSON.parse(file) }
  let(:transformed) { './transformed.json' }
  let(:class_instance) { JsonTransformer.new(json_data.to_json) }

  describe '#initialize' do
    it 'gets the json body' do
      expect(class_instance.json_body).to be_a_kind_of(Array)
    end
  end

  describe '#valid?' do
    let(:valid_input) do
      {
        'firstName' => 'Vial',
        'lastName' => 'Riobard',
        'email' => 'vial@calderon.bollay.com',
        'moreData' => { 'joceline' => 'kwasi', 'oceline' => 'wasi' },
        'phone' => '(750) 500-9253'
      }
    end
    let(:invalid_input) do
      {
        'firstName' => 'Vial',
        'lastName' => 'Riobard'
      }
    end
    it 'accept valid argument' do
      expect(class_instance.valid?(valid_input)).to be(true)
    end
    it 'reject invalid input' do
      expect(class_instance.valid?(invalid_input)).to be(false)
    end
  end

  describe '#collect_cleaned' do
    let(:repeated) { [{"firstName"=>"Vial", "lastName"=>"Riobard", "email"=>"vial@calderon.bollay.com", "moreData"=>{"phone"=>"(750) 500-9253", "joceline"=>"kwasi"}}, {"firstName"=>"Vial", "lastName"=>"Riobard", "moreData"=>{"phone"=>"(750) 500-9253", "oceline"=>"wasi"}}] }
    let(:merged) { [{"firstName"=>"Vial", "lastName"=>"Riobard", "email"=>"vial@calderon.bollay.com", "moreData"=>{"joceline"=>"kwasi", "oceline"=>"wasi"}, "phone"=>"(750) 500-9253"}] }
    let(:unique) { [{"firstName"=>"Garfield", "lastName"=>"Root", "email"=>"garfield@golda.secunda.com", "moreData"=>{"phone"=>"(983) 896-2295", "baptiste"=>"koziarz"}}] }
    it 'merges users with same first and last names' do
      expect(class_instance.collect_cleaned).to eql(merged)
    end
  end
end
