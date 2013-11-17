class Spree::Users::RegistrationsController < Spree::StoreController
  def new
    if user_signed_in?
      redirect_to _back_path
      flash[:notice] = Spree.t(:you_already_are_signed_in)
    end
  end 

  private

  def _back_path
    return params[:back] if params[:back].present?
    user_path current_user
  end
end