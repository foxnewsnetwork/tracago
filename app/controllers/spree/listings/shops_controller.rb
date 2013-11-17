class Spree::Listings::ShopsController < Spree::StoreController
  before_filter :_force_signin
  rescue_from ActiveRecord::RecordNotFound, with: :_handle_known_exceptions
  rescue_from Hash::EnforcedKeyMissing, with: :_handle_known_exceptions

  def new
    _listing
  end

  def create
    _attach_shop_to_listing! if _require_shop?
    _attach_pictures_to_listing!
    _goto_complete_step
  end

  private

  def _handle_known_exceptions(e)
    handler = Spree::Listings::Shops::ExceptionHandler.new e
    flash[:error] = handler.flash_message
    return _reload_this_step if handler.user_input_error?
    render_404
  end

  def _reload_this_step
    redirect_to new_listing_shop_path(_listing, _raw_shop_params)
  end

  def _goto_complete_step
    redirect_to _listing
  end

  def _attach_shop_to_listing!
    _listing.shop = _shop
    _listing.save!
  end

  def _attach_pictures_to_listing!
    _images.each { |image| _attach_picture_to_listing! image }
  end

  def _attach_picture_to_listing!(image)
    _listing.stockpile.images.create! attachment: image
  end

  def _images
    @images ||= params.require(:shop).enforce!(:images)[:images]
  end

  def _shop
    @shop ||= current_user.shop.try :tap do |shop| 
      shop.update _raw_shop_params
    end
    @shop ||= Spree::Shop.create! _shop_params
  end

  def _shop_params
    _raw_shop_params.merge user: current_user
  end

  def _raw_shop_params
    params.require(:shop).permit(:name, :email)
  end

  def _require_shop?
    _listing.require_shop?
  end

  def _force_signin
    redirect_to login_path _back_params unless user_signed_in?
  end

  def _back_params
    { back: new_listing_shop_path(_listing) }
  end

  def _listing
    @listing ||= Spree::Listing.find params[:listing_id]
  end
end