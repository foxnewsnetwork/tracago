Spree::Sample.load_sample("offers")

def attributes_generator(offer)
{
  shop: [offer.seller, offer.buyer].random,
  content: Faker::Lorem.paragraph
}
end
Spree::Offer.all.each do |offer|
  offer.comments.create! attributes_generator offer
end