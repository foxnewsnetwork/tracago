class Itps::Admins::TagsController < Itps::AdminBaseController

  def new
    @tag = Itps::Tag.new
  end

  def create
    _create_tag!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _create_tag!
    @create_result = _tag.valid? && _tag.save
  end

  def _render_flash!
    flash[:success] = t(:tag_successfully_created) if _create_success?
    flash[:notice] = t(:unable_to_create_tag) if _create_failed?
  end

  def _create_success?
    true == @create_result
  end

  def _create_failed?
    false == @create_result
  end

  def _get_out_of_here!
    return redirect_to itps_tag_path(_tag.permalink) if _create_success?
    render :new
  end

  def _tag
    @tag ||= Itps::Tag.new _tag_params
  end

  def _tag_params
    params.require(:itps_tag).permit(:presentation)
  end

end