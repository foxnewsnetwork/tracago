class Spree::Shops::RatingsController < Spree::StoreController

  def index
    _shop
  end 

  private

  def _shop
    @shop ||= Spree::Shop.find params[:shop_id]
  end
end