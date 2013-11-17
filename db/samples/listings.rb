Spree::Sample.load_sample("shops")
Spree::Sample.load_sample("stockpiles")

shop = Spree::Shop.find_by_name! "Admin Shop"

Spree::Stockpile.all.each do |stockpile|
  attributes = {
    stockpile: stockpile
  }
  shop.listings.create! attributes
end
