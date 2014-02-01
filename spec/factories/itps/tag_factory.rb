class JewFactory::Tag < JewFactory::Base
  def attributes
    { presentation: Faker::Company.name }
  end

end