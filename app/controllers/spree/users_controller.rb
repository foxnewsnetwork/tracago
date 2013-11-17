class Spree::UsersController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  
  def show
    _user
  end

  private

  def _user
    @user ||= Spree::User.find params[:id]
  end
end