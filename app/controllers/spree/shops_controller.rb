class Spree::ShopsController < Spree::StoreController
  
  def show
    _shop
  end

  private

  def _shop
    @shop ||= Spree::Shop.find params[:id]
  end
end