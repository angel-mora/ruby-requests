class JsonTransformer
  attr_reader :json_body

  def initialize(requested)
    @json_body = JSON.parse(requested)
    @exportable = []
    @merged = []
  end

  def format(arg)
    arg.gsub(/\D/, '').insert(0, '(').insert(4, ')').insert(5, ' ').insert(9, '-')
  end

  def valid?(arg)
    mail = !arg['email'].gsub(' ', '').match(URI::MailTo::EMAIL_REGEXP).nil? if arg['email']
    phone = arg['phone'].gsub(/\D/, '').length == 10 unless arg['phone'].nil?
    phone && mail ? true : false
  end

  def arrange_phone_of(user_hash)
    user_hash['phone'] = format(user_hash['moreData']['phone'])
    user_hash['moreData'].delete('phone')
  end

  def reduce_repeated(row)
    row.reduce do |first, second|
      first['moreData'] = first['moreData'].merge(second['moreData']) unless second['moreData'].nil?
      arrange_phone_of(first)
      @merged << first if valid?(first)
    end
  end
  
  def send_unique(row)
    arrange_phone_of(row[0])
    @merged << row[0] if valid?(row[0])
  end

  # Check if the row has repetition and deliver to merge accordingly
  def collect_cleaned
    @exportable.each do |row|
      reduce_repeated(row) if row.length > 1
      send_unique(row) if row[0]['phone'].nil? && row[0]['moreData']['phone']
    end
    sort_by_last_name(@merged)
    @merged
  end

  def remove_duplicates(array_of_hashes)
    array_of_hashes.group_by { |user| user['firstName'] && user['lastName'] }
      .map { |unique_user| @exportable << unique_user[1].map(&:merge!) }
  end

  # Handle json core actions
  def transform
    remove_duplicates(@json_body)
    collect_cleaned
    export(@merged)
  end

  def sort_by_last_name(arr_of_hashes)
    arr_of_hashes.sort_by! { |hash| hash['lastName'] }
  end

  # Export new json locally
  def export(json_file)
    File.open('./transformed.json', 'w+') do |file|
      JSON.dump(json_file, file)
    end
  end

  def loadable?(path)
    file = File.open(path)
    # Using JSON.parse instead of JSON.load for security purposes
    JSON.parse(file)
  end
end
