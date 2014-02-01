class Itps::DocTagsController < Itps::BaseController
  def show
    _doc_tag
  end
  private
  def _doc_tag
    @doc_tag ||= Itps::Tag.find_by_permalink! params[:id]
  end
end