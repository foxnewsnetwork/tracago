require_relative "./sample"
module Spree
  class SampleEngine < ::Rails::Engine
    engine_name 'spree_sample'

    # Needs to be here so we can access it inside the tests
    def self.load_samples

      # International materials trade related junk
      Spree::Sample.load_sample("addresses")
      Spree::Sample.load_sample("option_values")
      Spree::Sample.load_sample("assets")
      Spree::Sample.load_sample("materials")
      Spree::Sample.load_sample("users")
      Spree::Sample.load_sample("shops")
      Spree::Sample.load_sample("stockpiles")
      Spree::Sample.load_sample("origin_products")
      Spree::Sample.load_sample("listings")
      Spree::Sample.load_sample("taxons")
      Spree::Sample.load_sample("offers")
      Spree::Sample.load_sample("comments")
      Spree::Sample.load_sample("seaports")

      Spree::Sample.load_sample("finalizations")
      Spree::Sample.load_sample("post_transactions")
      Spree::Sample.load_sample("trucks")
      Spree::Sample.load_sample("ships")
      Spree::Sample.load_sample("escrows")
      Spree::Sample.load_sample("inspections")
      Spree::Sample.load_sample("service_contracts")
      Spree::Sample.load_sample("service_demands")
      Spree::Sample.load_sample("service_supplies")
      Spree::Sample.load_sample("ratings")
      Spree::Sample.load_sample("dispute_negotiations")
      

    end
  end
end