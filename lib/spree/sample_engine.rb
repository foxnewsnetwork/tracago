module Spree
  class SampleEngine < ::Rails::Engine
    engine_name 'spree_sample'

    # Needs to be here so we can access it inside the tests
    def self.load_samples
      # Spree::Sample.load_sample("payment_methods")
      # Spree::Sample.load_sample("shipping_categories")
      # Spree::Sample.load_sample("shipping_methods")
      # Spree::Sample.load_sample("tax_categories")
      # Spree::Sample.load_sample("tax_rates")
      # Spree::Sample.load_sample("products")
      # Spree::Sample.load_sample("product_option_types")
      # Spree::Sample.load_sample("product_properties")
      # Spree::Sample.load_sample("prototypes")
      # Spree::Sample.load_sample("variants")
      # Spree::Sample.load_sample("stock")

      # Spree::Sample.load_sample("orders")
      # Spree::Sample.load_sample("adjustments")
      # Spree::Sample.load_sample("payments")

      # International materials trade related junk
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