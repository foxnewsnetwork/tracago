class Itps::Escrows::StepsController < Itps::BaseController
  def new
    _form_helper
  end

  def create
    
  end

  private
  def _form_helper
    _escrow
  end

  def _escrow
    @escrow = Itps::Escrow.find_by_permalink! params[:escrow_id]
  end
end