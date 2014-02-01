class Itps::Admins::Tags::TagsController < Itps::Admins::TagsController
  def new
    @tag = _parent_tag.children.new
  end

  private
  def _create_tag!
    @create_result = _tag.valid? && _tag!.persisted?
  end

  def _tag!
    @tag = _parent_tag.children.create _tag_params 
  end

  def _tag
    @tag ||= _parent_tag.children.new _tag_params
  end

  def _parent_tag
    @parent_tag ||= Itps::Tag.find_by_permalink! params[:tag_id]
  end
end
