class Itps::StepsController < Itps::BaseController
  def show
    _step
  end

  private
  def _step
    @step ||= Itps::Escrows::Step.find_by_permalink! params[:id]
  end
end