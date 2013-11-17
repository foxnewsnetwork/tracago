class Spree::FinalizationsController < Spree::StoreController

  def show
    _finalization
  end

  private

  def _finalization
    @finalization ||= Spree::Finalization.find params[:id]
  end
end