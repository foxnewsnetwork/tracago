class Spree::ListingsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def show
    redirect_to stockpile_path Spree::Listing.find(params[:id]).stockpile
  end

  def new; end

  def create
    _create_listing!
    _setup_flash!
    _get_out_of_here!
  end

  def index
    _listings
  end

  private

  def _listings
    @listings ||= _query_handler.listings
  end

  def _query_handler
    @query_handler ||= Spree::Listings::QueryHandler.new _query_params
  end

  def _query_params
    params.permit(*Spree::Listings::QueryHandler::Fields).merge key: params[:key]
  end

  def _create_listing!
    @listing ||= _listing_maker.create! _listing_params if _valid?
  end

  def _listing
    @listing
  end

  def _stockpile
    _listing.stockpile
  end

  def _listing_maker
    current_user.try(:shop).try(:listings) || Spree::Listing
  end

  def _setup_flash!
    flash[:error] = _form_helper.errors.full_messages.join ", " unless _valid?
  end

  def _get_out_of_here!
    return _goto_shop_step if _require_shop?
    return _goto_finished_listing if _finished?
    return _reload_this_step
  end

  def _valid?
    _form_helper.valid?
  end

  def _reload_this_step
    render "new"
  end

  def _goto_finished_listing
    redirect_to listing_path _listing
  end

  def _finished?
    _valid? && _listing.complete?
  end

  def _require_shop?
    _valid? && _listing.require_shop?
  end

  def _goto_shop_step
    redirect_to new_listing_shop_path _listing
  end

  def _form_helper
    @form_helper ||= Spree::Listings::FormHelper.new _raw_stockpile_params
  end

  def _listing_params
    _form_helper.listing_params
  end

  def _raw_stockpile_params
    params.require(:listing).permit *Spree::Listings::StockpileParamsProcessor::Fields
  end

end