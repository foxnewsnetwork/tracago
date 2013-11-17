Spree::Sample.load_sample('finalizations')
Spree::Sample.load_sample('post_transactions')

def rating_param(finalization)
  {
    reviewable: finalization,
    reviewer: finalization.offer.seller,
    reviewed: finalization.offer.buyer,
    trustworthiness: rand(100),
    simplicity: rand(100),
    agreeability: rand(100),
    notes: Faker::Lorem.paragraph
  }
end

Spree::Finalization.all.each do |finalization|
  Spree::Rating.create! rating_param finalization
end

Spree::PostTransaction.all.map(&:finalization).each do |finalization|
  Spree::Rating.create! rating_param finalization
end