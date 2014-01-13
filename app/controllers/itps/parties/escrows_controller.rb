class Itps::Parties::EscrowsController < Itps::BaseController

  def index
    _escrows
  end

  private
  def _show_params
    params[:show] ||= "payment"
  end

  def _escrows
    _service_escrows if "service" == _show_params
    _payment_escrows if "payment" == _show_params
  end
  
  def _service_escrows
    return @escrows ||= _party.active_service_escrows if "active" == params[:type]
    return @escrows ||= _party.unready_service_escrows if "unready" == params[:type]
    return @escrows ||= _party.archive_service_escrows if "archive" == params[:type]
    return @escrows ||= _party.service_escrows
  end

  def _payment_escrows
    return @escrows ||= _party.active_payment_escrows if "active" == params[:type]
    return @escrows ||= _party.unready_payment_escrows if "unready" == params[:type]
    return @escrows ||= _party.archive_payment_escrows if "archive" == params[:type]
    return @escrows ||= _party.payment_escrows
  end

  def _party
    @party ||= Itps::Party.find params[:party_id]
  end
end