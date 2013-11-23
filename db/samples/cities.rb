Spree::Sample.load_sample("states")

california = Spree::State.find_by_local_presentation! "California"
new_york = Spree::State.find_by_local_presentation! "New York"
hong_kong = Spree::State.find_by_romanized_name! "Hong Kong"
states = Spree::State.all
cities = [
  {
    state: california,
    local_presentation: 'Los Angeles',
    romanized_name: 'los angeles'
  },
  {
    state: california,
    local_presentation: 'San Francisco',
    romanized_name: 'san francisco'
  },
  {
    state: new_york,
    local_presentation: 'New York',
    romanized_name: 'new york'
  },
  {
    state: hong_kong,
    local_presentation: hong_kong.local_presentation,
    romanized_name: 'Hong Kong'
  }
]

Spree::City.create! cities

50.times do
  Spree::City.create!(
    state: states.random,
    local_presentation: Faker::AddressUS.city,
    romanized_name: Faker::AddressUS.city)
end