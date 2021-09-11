require 'byebug'

class JsonTransformer
  attr_reader :json_body

  def initialize(requested)
    @json_body = requested
    @exportable = {}
  end

  def valid?
    # self.firstName.is_a(String)
    # self.lastName.is_a(String)
    # self.email.match mail regex or # self.moreData.phone match phone regex
  end

  def remove_duplicates
    # remove duplicates
  end

  def set_properly; end

  def transform
    # remove_duplicates(@json_body)
    @json_body.each do |user|
      user.set_properly if user.valid?
      @exportable << user
    end
  end

  def sort_by_last_name
    # sort alphabetically
  end

  def export
    # export new json locally
    # Json.dump(@exportable)
  end
end
