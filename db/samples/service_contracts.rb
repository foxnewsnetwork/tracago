Spree::Sample.load_sample("finalizations")
Spree::Sample.load_sample("shops")
Spree::Sample.load_sample("trucks")
Spree::Sample.load_sample("ships")
Spree::Sample.load_sample("inspections")
Spree::Sample.load_sample("escrows")

def _services
  @services ||= Spree::Serviceable.all_services
end

def random_service
  _services.random
end

Spree::Finalization.all.each do |finalization|
  Spree::ServiceContract.create! recipient: finalization,
    serviceable: random_service, 
    provider: Spree::Shop.first
end