Spree::Sample.load_sample('post_transactions')

def dispute_negotiation_params(pt)
  {
    shop: pt.relevant_shops.random,
    post_transaction: pt,
    amount: rand(3543),
    comment: Faker::Lorem.paragraph 
  }
end
Spree::PostTransaction.all.each do |pt|
  Spree::DisputeNegotiation.create! dispute_negotiation_params pt
end