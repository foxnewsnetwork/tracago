Spree::Sample.load_sample("option_types")

process = Spree::OptionType.find_by_presentation! "Process State"
packaging = Spree::OptionType.find_by_presentation! "Packaging"

Spree::OptionValue.create!([
  {
    name: "Supersacks",
    presentation: "Supersacks",
    option_type: packaging
  },
  {
    name: "No packaging",
    presentation: "No packaging",
    option_type: packaging
  },
  {
    name: "Gaylord",
    presentation: "Gaylord",
    option_type: packaging
  },
  {
    name: "Pallet",
    presentation: "Pallet",
    option_type: packaging
  },
  {
    name: "Baled",
    presentation: "Baled",
    option_type: packaging
  },
  {
    name: "Hotwashed",
    presentation: "Hot washed",
    option_type: process
  },
  {
    name: "Reground",
    presentation: "Regrind",
    option_type: process
  },
  {
    name: "Condensed",
    presentation: "Condensed",
    option_type: process
  }
])