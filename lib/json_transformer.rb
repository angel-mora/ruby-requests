require 'byebug'

class JsonTransformer
  attr_reader :json_body

  def initialize(requested)
    @json_body = JSON.parse(requested)
    @exportable = []
  end

  def format(arg)
    arg.gsub(/\D/, '').insert(0,'(').insert(4,')').insert(5,' ').insert(9, '-')
  end

  def valid?(arg)
    mail = !!arg['email'].gsub(' ','').match(URI::MailTo::EMAIL_REGEXP)
    phone = arg['phone'].gsub(/\D/, '').length == 10
    phone && mail
  end

  def remove_duplicates(array_of_hashes)
    # remove duplicates
    # @exportable = []
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
          first['phone'] = format(first['moreData']['phone']) if first['phone'].nil?
          first['moreData'].delete('phone')
          @merged << first if valid?(first)
        end
      else
        unique = repeated[0]
        if unique['phone'].nil? && unique['moreData']['phone']
          unique['phone'] = format(unique['moreData']['phone'])
          unique['moreData'].delete('phone')
          @merged << unique if valid?(unique)
        end
      end
    end
    sort_by_last_name(@merged)
    @merged
  end

  def set_properly; end

  def transform
    remove_duplicates(@json_body)
    export(@merged)
  end

  def sort_by_last_name(arr_of_hashes)
    arr_of_hashes.sort_by! { |hash| hash['lastName'] }
  end

  # export new json locally
  def export(json_file)
    File.open('./transformed.json', 'w+') do |file|
      JSON.dump(json_file, file)
    end
  end

  def loadable?(path)
    file = File.open(path)
    JSON.load(file)
  end
end
