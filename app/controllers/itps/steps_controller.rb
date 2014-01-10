class Itps::StepsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account,
    except: [:show]
  def show
    _step
  end

  def edit
    _step
  end

  def destroy
    _destroy_step!
    _render_flash!
    _get_out_of_here!
  end
  private

  def _correct_accounts
    _step.escrow.relevant_accounts
  end

  def _destroy_step!
    _escrow
    @destroy_result = _step.destroy
  end

  def _destroy_success?
    true == @destroy_result
  end

  def _destroy_failed?
    false == @destroy_result
  end

  def _render_flash!
    flash[:error] = t(:unable_to_delete) if _destroy_failed?
    flash[:success] = t(:successfully_deleted) if _destroy_success?
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