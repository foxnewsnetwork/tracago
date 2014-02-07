class Itps::Admins::EscrowsController < Itps::AdminBaseController
  def index
    return _unclaimed_escrows if _unclaimed?
    return _open_escrows if _open?
    return _archived_escrows if _archived?
    return _edit_mode_escrows if _edit_mode?
    return _katame_escrows if _katame?
    return _all_escrows
  end

  private
  def _unclaimed_escrows
    _e :unclaimed
  end
  def _open_escrows
    _e :active
  end
  def _archived_escrows
    _e :archived
  end
  def _edit_mode_escrows
    _e :edit_mode
  end
  def _katame_escrows
    _e :waiting_for_both_sides_to_agree
  end
  def _all_escrows
    _e :order_by_latest
  end
  def _e(scope_name)
    @escrows ||= Itps::Escrow.send(scope_name).page(params[:page]).per(params[:per_page])
  end
  def _unclaimed?
    'unclaimed' == params[:q].to_s
  end
  def _open?
    'open' == params[:q].to_s
  end
  def _archived?
    'archived' == params[:q].to_s
  end
  def _edit_mode?
    'edit_mode' == params[:q].to_s
  end
  def _katame?
    'katame' == params[:q].to_s
  end
end