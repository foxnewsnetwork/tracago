class Itps::DocumentsController < Itps::BaseController
  def show
    _document
  end

  def edit
    _document
  end

  private
  def _document
    @document ||= Itps::Escrows::Document.find_by_permalink! params[:id]
  end
end