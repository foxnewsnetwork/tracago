module Spree
  class StoreController < Spree::BaseController
    layout 'spree/layouts/application'
    
    def unauthorized
      render 'spree/shared/unauthorized', :status => 401
    end

    private
    def config_locale
      Spree::Config[:locale]
    end
  end
end

