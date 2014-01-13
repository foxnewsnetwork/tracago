module Itps::Parties::EscrowsHelper
  def counter(type: type, show: show)
    type, show = type.to_s, show.to_s
    return _party.active_payment_escrows.count if "active" == type && "payment" == show
    return _party.active_service_escrows.count if "active" == type && "service" == show
    return _party.unready_payment_escrows.count if "unready" == type && "payment" == show
    return _party.unready_service_escrows.count if "unready" == type && "service" == show
    return _party.archive_payment_escrows.count if "archive" == type && "payment" == show
    return _party.archive_service_escrows.count if "archive" == type && "service" == show
  end

  def path(opts={})
    itps_party_escrows_path _party, opts
  end

  def class_check(type, show=nil)
    return _right_type?(type) & _right_show?(show) ? :active : :inactive
  end

  private
  def _party
    @party
  end

  def _right_type?(type)
    params[:type].to_s == type.to_s
  end

  def _right_show?(show)
    params[:show].to_s == show.to_s
  end
end