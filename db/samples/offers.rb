Spree::Sample.load_sample("listings")
Spree::Sample.load_sample("shops")

def all_shop
  @all_shop ||= Spree::Shop.all
end

def offer_attributes_array(s)
  all_shop.reject do |shop|
    shop.id == s.id
  end.map do |shop|
    { 
      shop: shop,
      address: shop.address,
      expires_at: rand(243).days.from_now,
      usd_per_pound: (rand(350).to_f / 2000 + 1),
      loads: rand(4545),
      transport_method: Spree::Offer::TransportMethods.random
    }
  end.slice(0, rand(all_shop.length))
end
Spree::Listing.all.each do |listing|
  array = offer_attributes_array listing.shop
  listing.offers.create! array if array.present?
end

