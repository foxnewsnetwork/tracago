united_states = Spree::Country.find_by_name!("United States")
new_york = Spree::State.find_by_name!("New York")
california = Spree::State.find_by_name! "California"
# Billing address
Spree::Address.create!(
  :firstname => Faker::Name.first_name,
  :lastname => Faker::Name.last_name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => Faker::Address.city,
  :state => new_york,
  :zipcode => 16804,
  :country => united_states,
  :phone => Faker::PhoneNumber.phone_number)

#Shipping address
Spree::Address.create!(
  :firstname => Faker::Name.first_name,
  :lastname => Faker::Name.last_name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => Faker::Address.city,
  :state => new_york,
  :zipcode => 16804,
  :country => united_states,
  :phone => Faker::PhoneNumber.phone_number)

# Shop Address
Spree::Address.create!(
  :nickname => "Admin Shop",
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => Faker::Address.city,
  :state => california,
  :zipcode => 90210,
  :country => united_states,
  :phone => Faker::PhoneNumber.phone_number)

10.times do
  Spree::Address.create!(
    :address1 => Faker::Address.street_address,
    :address2 => Faker::Address.secondary_address,
    :city => Faker::Address.city,
    :state => california,
    :zipcode => 90210,
    :country => united_states,
    :phone => Faker::PhoneNumber.phone_number)
end