class Itps::Escrows::MoneyTransfersController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account

  def index
    _money_transfers
  end

  private
  def _correct_accounts
    _escrow.relevant_accounts
  end

  def _money_transfers
    @money_transfers ||= _escrow.money_transfers.order('updated_at desc').page(params[:page]).per(params[:per_page])
  end

  def _escrow
    @escrow ||= Itps::Escrow.find_by_permalink! params[:escrow_id]
  end
end