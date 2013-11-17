Spree::Sample.load_sample("finalizations")
Spree::Sample.load_sample("seaports")

def generate_ship_params(finalization)
  { 
    start_port: Spree::Seaport.first,
    finish_port: Spree::Seaport.last,
    start_terminal_code: "A",
    finish_terminal_code: "A",
    carrier_name: Faker::Company.name,
    vessel_id: Faker::Name.first_name,
    depart_at: 10.days.from_now,
    arrive_at: 40.days.from_now,
    cutoff_at: 4.days.from_now,
    containers: rand(4),
    pull_at: 1.day.from_now,
    return_at: 2.days.from_now,
    usd_price: rand(3243),
    contact_name: Faker::Name.name,
    contact_email: Faker::Internet.email,
    contact_phone: Faker::PhoneNumber.phone_number
  }
end

Spree::Finalization.all.each do |finalization|
  Spree::Serviceables::Ship.create! generate_ship_params finalization
end