Spree::Sample.load_sample("users")
Spree::Sample.load_sample("addresses")

user = Spree::User.find_by_email! "admin@thomaschen.co"
address = Spree::Address.find_by_fullname! "Admin Shop"
::Spree::Shop.create!(
  user: user,
  name: "Admin Shop",
  email: "shop@thomaschen.co",
  address: address)

def all_addresses
  @all_addresses ||= Spree::Address.all
end

def random_address
  all_addresses[rand(all_addresses.length)]
end

Spree::User.all.reject do |user|
  user.shop.present?
end.each do |user|
  Spree::Shop.create! user: user,
    name: Faker::Company.name,
    email: Faker::Internet.email,
    address: random_address
end