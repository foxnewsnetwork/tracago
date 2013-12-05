class Spree::UsersController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  include Spree::UserFilterHelper
  before_filter :filter_anonymous_users, 
    :filter_incorrect_users  
  
  def show
    _user
  end

  private

  def _correct_user
    _user
  end

  def _user
    @user ||= Spree::User.find params[:id]
  end
end