module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      _stockpiles
    end

    private

    def _stockpiles
      @stockpiles ||= Spree::Stockpile.completed
    end
  end
end
