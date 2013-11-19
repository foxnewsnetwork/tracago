module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      _stockpiles && _services
    end

    private

    def _stockpiles
      @stockpiles ||= Spree::Stockpile.latest_completed.limit(4)
    end

    def _services
      @services ||= (_service_demands + _service_supplies).sort do |a,b| 
        b.created_at <=> a.created_at
      end.take(4)
    end

    def _service_demands
      Spree::ServiceDemand.latest_unfulfilled(4)
    end

    def _service_supplies
      Spree::ServiceSupply.latest(4)
    end

  end
end
