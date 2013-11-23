Spree::Sample.load_sample("addresses")

hong_kong = Spree::Address.find_by_fullname! "Hong Kong Port"
Spree::Seaport.create!(
  port_code: "CNAIN",
  port_name: "Huaiyin",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNAKL",
  port_name: "Alatawshankou",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNANS",
  port_name: "Anshun",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNAQG",
  port_name: "Anqing",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNART",
  port_name: "Arhaxat",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNASN",
  port_name: "Anshan",
  address: hong_kong)
Spree::Seaport.create!(
  port_code: "CNBAD",
  port_name: "Baoding",
  address: hong_kong) 