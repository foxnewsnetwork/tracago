Spree::Sample.load_sample("shops")
Spree::Sample.load_sample("trucks")
Spree::Sample.load_sample("ships")
Spree::Sample.load_sample("inspections")
Spree::Sample.load_sample("escrows")

def _services
  @services ||= Spree::Serviceable.all
end

def random_service
  _services.random
end

Spree::Finalization.all.each do |finalization|
  Spree::ServiceSupply.create! shop: Spree::Shop.first,
    serviceable: random_service
end