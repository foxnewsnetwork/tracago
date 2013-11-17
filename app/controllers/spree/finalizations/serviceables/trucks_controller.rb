class Spree::Finalizations::Serviceables::TrucksController < Spree::StoreController
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

  def _correct_shops
    _finalization.relevant_shops
  end

  def _valid?
    _form_helper.valid?
  end

  def _setup_flash!
    flash[:error] = Spree.t(:you_have_errors) unless _valid?
  end

  def _create_demand!
    return unless _valid?
    @truck_demand ||= _finalization.service_demands.create! serviceable: _truck_serviceable
  end

  def _truck_serviceable
    @truck_serviceable ||= Spree::Serviceables::Truck.create! _truck_params
  end

  def _truck_params
    _form_helper.truck_params
  end

  def _form_helper
    @form_helper ||= Spree::Finalizations::Serviceables::Trucks::FormHelper.new _raw_truck_serviceable_params
  end

  def _raw_truck_serviceable_params
    params.require(:serviceable).permit *Spree::Finalizations::Serviceables::Trucks::FormHelper::Fields
  end

  def _get_out_of_here!
    return redirect_to demand_path(@truck_demand) if _valid?
    return render :new
  end

  def _finalization
    @finalization ||= Spree::Finalization.find params[:finalization_id]
  end

end