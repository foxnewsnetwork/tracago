class Spree::OffersController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include Spree::OffersHelper
  include Spree::UserFilterHelper
  before_filter :filter_anonymous_users, :filter_incorrect_users, except: [:show]
  def show
    _offer
  end

  def edit
    _offer_edit_helper
  end

  def update
    _consider_update_offer!
    _setup_flash!
    render :edit
  end

  private

  def _correct_shop
    _offer.shop
  end

  def _setup_flash!
    flash[:notice] = Spree.t(:update_successful) if _valid?
    flash[:error] = _offer_edit_helper.error_flash unless _valid?
  end

  def _valid?
    _offer_edit_helper.valid?
  end

  def _consider_update_offer!
    _offer.update!(_offer_edit_helper.offer_params) if _valid?
  end

  def _offer_edit_helper
    @offer_edit_helper ||= Spree::Offers::EditFormHelper.new _offer_params
  end

  def _offer_params
    return _existing_params if "edit" == params[:action]
    return _existing_params.merge _input_params if "update" == params[:action]
    throw "Bad action calls for _offer_params"
  end

  def _existing_params
    Spree::Offers::ParamsTenderizer.new(_offer).offer_params
  end

  def _input_params
    params.require(:offer_edit_form).permit(*Spree::Offers::ParamsProcessor::AllFields).symbolize_keys
  end

  def _offer
    @offer ||= Spree::Offer.find params[:id]
  end
end