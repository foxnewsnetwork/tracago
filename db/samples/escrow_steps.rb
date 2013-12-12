Spree::Sample.load_sample("finalizations")

Spree::Finalization.all.map(&:escrow_steps)