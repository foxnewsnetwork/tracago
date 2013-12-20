class Itps::StepsController < Itps::BaseController
  def show
    _step
  end

  def destroy
    _destroy_step!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _destroy_step!
    _escrow
    @result ||= _step.destroy
  end

  def _render_flash!
    flash[:error] = t(:unable_to_delete) unless @result
    flash[:notice] = t(:successfully_deleted) if @result
  end

  def _get_out_of_here!
    redirect_to itps_escrow_path(_escrow.permalink)
  end

  def _escrow
    @escrow ||= _step.escrow
  end

  def _step
    @step ||= Itps::Escrows::Step.find_by_permalink! params[:id]
  end
end