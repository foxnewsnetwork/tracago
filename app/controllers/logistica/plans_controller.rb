class Logistica::PlansController < Logistica::BaseController
  def show
    _downcast_plan
  end
  private
  def _downcast_plan
    @plan = _plan.downcast
  end

  def _plan
    @plan ||= Logistica::Plan.find params[:id]
  end
end