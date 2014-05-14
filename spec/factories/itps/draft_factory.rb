class JewFactory::Draft < JewFactory::Base
  attr_accessor :attributes
  attr_hash_accessor :account

  def belongs_to(thing)
    tap do |f|
      f.account = thing if thing.is_a? Itps::Account
    end
  end

  def initialize
    self.account = Itps::Account.find ChineseFactory::User.mock.id
  end

  def attributes
    {
      content: _full_hash.to_yaml
    }
  end

  private
  def _full_hash
    {
      buyer_email: account.email,
      buyer_company_name: Faker::Company.name,
      seller_email: account.email,
      seller_company_name: Faker::Company.name,
      preloading_pictures: '1',
      weight_ticket: '1',
      loading_pictures: '1',
      bill_of_lading: '1',
      packing_list: '1',
      invoice: '1'
    }
  end
end