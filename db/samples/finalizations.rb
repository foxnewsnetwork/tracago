Spree::Sample.load_sample("offers")

Spree::Offer.limit(50).each do |offer|
  Spree::Finalization.create! offer: offer,
    expires_at: 10.days.from_now
end