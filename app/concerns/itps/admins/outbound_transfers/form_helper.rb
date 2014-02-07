class Itps::Admins::OutboundTransfers::FormHelper < Itps::Admins::InboundTransfers::FormHelper

  private
  def _money_params
    { 
      inbound: false,
      dollar_amount: dollar_amount,
      memo: memo
    }
  end
end