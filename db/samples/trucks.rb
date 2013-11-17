Spree::Sample.load_sample("finalizations")

def generate_truck_param(finalization)
  {
    destination: finalization.destination,
    origination: finalization.origination,
    pickup_at: 1.day.from_now,
    arrive_at: 2.days.from_now,
    usd_price: rand(2453)
  }
end

Spree::Finalization.all.each do |finalization|
  Spree::Serviceables::Truck.create! generate_truck_param finalization
end