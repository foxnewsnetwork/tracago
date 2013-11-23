Spree::Sample.load_sample("cities")

new_york = Spree::City.find_by_local_presentation! "New York"
san_francisco = Spree::City.find_by_local_presentation! "San Francisco"
los_angeles = Spree::City.find_by_local_presentation! "Los Angeles"
hong_kong = Spree::City.find_by_romanized_name! "Hong Kong"
cities = Spree::City.all

Spree::Address.create!(
  fullname: "Hong Kong Port",
  address1: Faker::AddressUK.street_address,
  address2: Faker::AddressUK.secondary_address,
  city: hong_kong,
  zipcode: 23232,
  phone: Faker::PhoneNumber.phone_number)

# Billing address
Spree::Address.create!(
  :fullname => Faker::Name.name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => new_york,
  :zipcode => 16804,
  :phone => Faker::PhoneNumber.phone_number)

#Shipping address
Spree::Address.create!(
  :fullname => Faker::Name.name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => san_francisco,
  :zipcode => 16804,
  :phone => Faker::PhoneNumber.phone_number)

# Shop Address
Spree::Address.create!(
  :fullname => "Admin Shop",
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => los_angeles,
  :zipcode => 90210,
  :phone => Faker::PhoneNumber.phone_number)

10.times do
  Spree::Address.create!(
    :address1 => Faker::Address.street_address,
    :address2 => Faker::Address.secondary_address,
    :city => cities.random,
    :zipcode => 90210,
    :phone => Faker::PhoneNumber.phone_number)
end