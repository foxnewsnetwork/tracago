class Spree::Seaports::Factory
  class << self
    def create!(params={})
      Spree::Seaport.create! params.permit(:port_code, :port_name)
    end
  end
end