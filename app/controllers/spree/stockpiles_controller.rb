class Spree::StockpilesController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper 'spree/taxons'
  before_filter :_only_show_completed_stockpiles, 
    except: [:destroy]
  before_filter :_filter_anonymous_users, 
    :_filter_bad_users, 
    except: [:show]
  include Spree::SessionsHelper
  def show
    _stockpile
  end

  def edit
    _listing
  end

  def edit_address
    _address
  end

  def edit_picture
    _pictures
  end

  def edit_sellers_offer
    _offer
  end

  def destroy
    _destroy_stockpile!
    _setup_flash!
    _get_out!
  end


  private

  def _filter_bad_users
    unless correct_user_session? _stockpile.owner
      redirect_to stockpile_path _stockpile
      flash[:error] = Spree.t(:you_need_to_be_owner_to_make_changes)
    end
  end

  def _filter_anonymous_users
    unless user_signed_in?
      redirect_to login_path back: request.fullpath
      flash[:error] = Spree.t(:if_you_are_the_owner_you_must_login_to_make_changes)
    end
  end

  def _only_show_completed_stockpiles
    unless _stockpile.completed?
      redirect_to root_path 
      flash[:error] = Spree.t(:not_listing_is_not_ready_yet)
    end
  end

  def _destroy_stockpile!
    @destroyed_stockpile ||= _stockpile.destroy
  end

  def _setup_flash!
    return flash[:notice] = Spree.t(:your_listing_has_been_removed) if _destroy_stockpile!
    flash[:error] = Spree.t(:something_went_wrong_with_removing_your_listing)
  end

  def _get_out!
    return redirect_to root_path if _destroy_stockpile!
    redirect_to stockpile_path _stockpile
  end

  def _listing
    @listing ||= _stockpile.listing
  end

  def _address
    @address ||= _stockpile.address
  end

  def _pictures
    @pictures ||= _stockpile.images
  end

  def _offer
    @offer ||= _stockpile.seller_offer
  end

  def accurate_title
    _stockpile.present? ? _stockpile.name : super
  end

  def _stockpile
    @stockpile ||= Spree::Stockpile.find_by_id! params[:id]
  end
end
