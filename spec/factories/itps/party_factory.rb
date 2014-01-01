# == Schema Information
#
# Table name: itps_parties
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  email        :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class JewFactory::Party < JewFactory::Base
  def attributes
    {
      company_name: Faker::Company.name,
      email: Faker::Internet.email
    }
  end
end
