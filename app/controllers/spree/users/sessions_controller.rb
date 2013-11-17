class Spree::Users::SessionsController < Spree::StoreController
  before_filter :_back_path
  
  def new 
    if user_signed_in?
      flash[:notice] = Spree.t(:you_are_already_signed_in)
      redirect_to _return_path
    end
  end

  private

  def _return_path
    return _back_path if _back_path.present?
    user_path current_user
  end

  def _back_path
    @back_path ||= params[:back]
  end
end