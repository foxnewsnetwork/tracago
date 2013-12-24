class JewFactory::Party < JewFactory::Base
  def attributes
    {
      company_name: Faker::Company.name,
      email: Faker::Internet.email
    }
  end
end