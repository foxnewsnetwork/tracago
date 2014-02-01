class Itps::Admins::DocumentationsController < Itps::AdminBaseController

  def new
    _form_helper
  end

  def create
    _documentation!
    _render_flash!
    _get_out_of_here!
  end

  private
  def _documentation!
    @documentation = _form_helper.documentation! if _create_success?
  end

  def _create_success?
    _creative_form_helper.create_success?
  end

  def _create_failed?
    _creative_form_helper.create_failed?
  end

  def _render_flash!
    flash[:success] = t(:documentation_successfully_written) if _create_success?
    flash[:error] = t(:unable_to_create) if _create_failed?
  end

  def _get_out_of_here!
    return redirect_to itps_documentation_path _documentation.permalink if _create_success?
    render :new
  end

  def _documentation
    @documentation
  end

  def _form_helper
    @form_helper ||= Itps::Admins::Documentations::FormHelper.new
  end

  def _creative_form_helper
    _form_helper.tap do |f|
      f.attributes = _documentation_params
    end
  end

  def _documentation_params
    params.require(:documentations).permit *Itps::Admins::Documentations::FormHelper::Fields
  end
end