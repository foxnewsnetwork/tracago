class Itps::Admins::DocumentsController < Itps::AdminBaseController
  def index
    _documents
  end
  private
  def _documents
    @documents ||= Itps::Escrows::Document.waiting_approval
  end
end