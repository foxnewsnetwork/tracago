module Spree
  class StoreController < Spree::BaseController

    def unauthorized
      render 'spree/shared/unauthorized', :status => 401
    end

    protected
      def config_locale
        Spree::Config[:locale]
      end
  end
end

