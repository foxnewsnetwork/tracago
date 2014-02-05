# == Schema Information
#
# Table name: itps_tags
#
#  id           :integer          not null, primary key
#  permalink    :string(255)      not null
#  presentation :string(255)      not null
#

class JewFactory::Tag < JewFactory::Base
  def attributes
    { presentation: Faker::Company.name }
  end

end
