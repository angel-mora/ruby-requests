require 'byebug'

class JsonTransformer
  attr_reader :json_body

  def initialize(requested)
    @json_body = JSON.parse(requested)
  end

  def valid?(arg)
    mail = !!arg['email'].gsub(' ','').match(URI::MailTo::EMAIL_REGEXP)
    phone = arg['phone'].gsub(/\D/, '').length == 10
    phone && mail
  end

  def remove_duplicates(array_of_hashes)
    # remove duplicates
    @exportable = []
    @merged = []
    grouped = array_of_hashes.group_by do |user|
      user['firstName'] && user['lastName']
    end
    grouped.map do |unique_user|
      unique_user = unique_user[1].map(&:merge!)
      @exportable << unique_user
    end
    @exportable.each do |repeated|
      if repeated.length > 1
        repeated.reduce do |first, second|
          first['moreData'] = first['moreData'].merge(second['moreData']) unless second['moreData'].nil?
          first['phone'] = first['moreData']['phone'] if first['phone'].nil?
          first['moreData'].delete('phone')
          @merged << first if valid?(first)
        end
      else
        unique = repeated[0]
        if unique['phone'].nil? && unique['moreData']['phone']
          unique['phone'] = unique['moreData']['phone']
          unique['moreData'].delete('phone')
          @merged << unique if valid?(unique)
        end
      end
    end
    p @merged
    byebug
  end

  def set_properly; end

  def transform
    remove_duplicates(@json_body)
    #@json_body.each do |user|
      #user.set_properly if user.valid?
      #@exportable << user
    #end
  end

  def sort_by_last_name
    # sort alphabetically
  end

  def export
    # export new json locally
    # Json.dump(@exportable)
  end
end
