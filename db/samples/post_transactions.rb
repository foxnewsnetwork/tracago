Spree::Sample.load_sample("finalizations")

Spree::Finalization.limit(25).each do |finalization|
  Spree::PostTransaction.create! finalization: finalization
end