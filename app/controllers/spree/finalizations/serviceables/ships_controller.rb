class Spree::Finalizations::Serviceables::ShipsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include Spree::UserFilterHelper
  before_filter :filter_anonymous_users, :filter_incorrect_users

  def new
    _finalization
  end

  def create
    _create_demand!
    _setup_flash!
    _get_out_of_here!
  end

  private

  def _create_demand!
    @ship_demand ||= _finalization.service_demands.create! serviceable: _ship_serviceable if _valid?
  end

  def _ship_serviceable
    @ship_serviceable ||= Spree::Serviceables::Ship.create! _ship_serviceable_params
  end

  def _valid?
    _form_helper.valid?
  end

  def _ship_serviceable_params
    _form_helper.ship_serviceable_params
  end

  def _form_helper
    @form_helper ||= Spree::Finalizations::Serviceables::Ships::FormHelper.new _raw_ship_serviceable_params
  end

  def _raw_ship_serviceable_params
    params.require(:serviceable).permit *Spree::Finalizations::Serviceables::Ships::FormHelper::Fields
  end

  def _setup_flash!
    flash[:error] = Spree.t(:you_have_errors) unless _valid?
  end

  def _get_out_of_here!
    return redirect_to demand_path(@ship_demand) if _valid?
    return render :new
  end

  def _correct_shops
    _finalization.relevant_shops
  end

  def _finalization
    @finalization ||= Spree::Finalization.find params[:finalization_id]
  end

end