Spree::Sample.load_sample("countries")

united_states = Spree::Country.find_by_iso! "US"
china = Spree::Country.find_by_iso! "CN"
states = [
  {
    romanized_name: "California",
    abbr: "CA",
    local_presentation: "California",
    country: united_states
  },
  {
    romanized_name: "New York",
    abbr: "NY",
    local_presentation: "New York",
    country: united_states
  },
  {
    romanized_name: "Arizona",
    abbr: "AZ",
    local_presentation: "Arizona",
    country: united_states
  },
  {
    romanized_name: 'Hong Kong',
    abbr: 'HK',
    local_presentation: "香港",
    country: china
  }
]

Spree::State.create! states
