Spree::User.create! :email => "admin@thomaschen.co", 
  :password => "asdf123", 
  :password_confirmation => "asdf123"
50.times do
  Spree::User.create! email: Faker::Internet.email, password: "asdf123", :password_confirmation => "asdf123"
end