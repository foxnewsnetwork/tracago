class Itps::DocumentationsController < Itps::BaseController

  def show
    _documentation
    _doc_tag
  end

  private
  def _doc_tag
    @doc_tag ||= _documentation.active_tag
  end

  def _documentation
    @documentation ||= Itps::Documentation.find_by_permalink! params[:id]
  end
end