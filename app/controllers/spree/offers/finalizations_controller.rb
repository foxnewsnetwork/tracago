class Spree::Offers::FinalizationsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include Spree::UserFilterHelper
  before_filter :filter_anonymous_users, :filter_incorrect_users

  def new
    _offer
  end

  def create
    _create_finalization!
    _setup_flash!
    _get_out_of_here!
  end

  private

  def _correct_shop
    _offer.seller
  end

  def _setup_flash!
    flash[:error] = Spree.t(:this_offer_cannot_be_accepted_yet) unless _valid?
  end

  def _get_out_of_here!
    return redirect_to finalization_path @finalization if _valid?
    return render "new"
  end

  def _create_finalization!
    @finalization ||= Spree::Finalization.create! _finalization_params if _valid?
  end

  def _valid?
    @valid_flag ||= _offer.acceptable?
  end

  def _finalization_params
    _raw_finalization_params.merge offer: _offer
  end

  def _raw_finalization_params
    params.require(:finalization).permit :expires_at
  end

  def _offer
    @offer ||= Spree::Offer.find params[:offer_id]
  end
end