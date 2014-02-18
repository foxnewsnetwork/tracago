class Itps::Steps::PutsController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  before_filter :_filter_edit_mode_escrows,
    only: [:approve]
  before_filter :_filter_lock_mode_escrows,
    only: [:update]
  def approve
    _approve_step!
    _render_flash!
    _get_out_of_here!
  end

  def update
    _update_step!
    _render_flash!
    _get_out_of_here!
  end

  def swap_down
    _swap_down! 
    _render_flash!
    _get_out_of_here!
  end

  def swap_up
    _swap_up!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _filter_edit_mode_escrows
    if _step.edit_mode?
      redirect_to itps_step_path _step.permalink
      flash[:error] = t(:you_should_not_approve_of_things_in_edit_mode)
    end
  end

  def _filter_lock_mode_escrows
    if _step.escrow.locked?
      redirect_to itps_step_path _step.permalink
      flash[:error] = t(:you_should_not_approve_of_things_in_edit_mode)
    end
  end

  def _correct_accounts
    _escrow.relevant_accounts
  end

  def _approve_step!
    @approve_result = _step.complete!
  end

  def _get_out_of_here!
    return redirect_to itps_step_path(_step.permalink) if _update_successful?
    return redirect_to itps_escrow_path(_escrow.permalink)
  end

  def _render_flash!
    flash[:error] = t(:update_was_unsuccessful) if _update_failed?
    flash[:success] = t(:update_successful) if _update_successful?
    flash[:error] = t(:swap_position_failed) if _swap_unsuccessful?
    flash[:success] = t(:swap_position_successful) if _swap_successful?
    flash[:error] = t(:approval_failed) if _approve_failed?
    flash[:success] = t(:approval_success) if _approve_success?
  end

  def _approve_success?
    true == @approve_result
  end

  def _approve_failed?
    false == @approve_result
  end

  def _update_successful?
    true == @update_result
  end

  def _update_failed?
    false == @update_result
  end

  def _swap_unsuccessful?
    false == @swap_result
  end

  def _swap_successful?
    true == @swap_result
  end
  
  def _update_step!
    @update_result ||= _step.update _steps_params
  end

  def _steps_params
    params.require(:itps_escrows_step).permit(:title, :instructions, :position, :class_name)
  end

  def _swap_down!
    @swap_result ||= _step.swap_down!
  end

  def _swap_up!
    @swap_result ||= _step.swap_up!
  end

  def _escrow
    _step.escrow
  end

  def _step
    @step ||= Itps::Escrows::Step.find_by_permalink! params[:id]
  end
end