class Itps::Admins::EmailArchivesController < Itps::AdminBaseController
  def index
    _email_archives
  end

  def show
    render text: _email_archive.to_mail.to_s, layout: false
  end
  private
  def _email_archives
    @email_archives ||= Itps::EmailArchive.order('created_at desc').page(params[:page]).per(params[:per_page])
  end

  def _email_archive
    @email_archive ||= Itps::EmailArchive.find params[:id]
  end
end