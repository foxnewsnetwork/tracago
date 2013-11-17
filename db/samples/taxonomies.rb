taxonomies = [
  { :name => "Categories" },
  { :name => "Company" },
  { :name => "Location" },
  { :name => "Origin Product" },
  { :name => "Packaging" }
]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.create!(taxonomy_attrs)
end
