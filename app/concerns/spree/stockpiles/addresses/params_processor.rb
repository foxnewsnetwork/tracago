class Spree::Stockpiles::Addresses::ParamsProcessor

  def initialize(params)
    @params = params
  end

  def params
    @params.tap do |hash|
      hash[:state] = Spree::State.normalize hash[:state]
      hash[:country] = Spree::Country.normalize hash[:country]
    end
  end

end