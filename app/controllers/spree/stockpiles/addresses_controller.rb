class Spree::Stockpiles::AddressesController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_filter :_consider_skipping_to_next_step,
    except: [:edit]
  def new
    _stockpile
  end

  def edit
    _stockpile
  end

  def create
    if _valid?
      _attach_address_to_stockpile!
      _goto_shop_step
    else
      _handle_flash
      _reload_this_step
    end
  end

  private

  def _handle_flash
    flash[:error] = _form_helper.flash_message
  end

  def _reload_this_step
    render "new"
  end

  def _valid?
    _form_helper.valid?
  end

  def _consider_skipping_to_next_step
    _goto_shop_step unless _require_address?
  end

  def _require_address?
    _stockpile.require_address?
  end

  def _goto_shop_step
    redirect_to new_listing_shop_path _stockpile.listing
  end

  def _attach_address_to_stockpile!
    _stockpile.address = _address
    _stockpile.save!
  end

  def _address
    @address ||= Spree::Address.find_roughly_or_create_by _address_params
  end

  def _address_params
    _form_helper.address_params.symbolize_keys
  end

  def _form_helper
    @form_helper ||= Spree::Stockpiles::Addresses::FormHelper.new _raw_address_params, _stockpile
  end

  def _raw_address_params
    params.require(:address_form_helper).permit :address1,
      :address2,
      :city,
      :zipcode,
      :state,
      :country
  end

  def _stockpile
    @stockpile ||= Spree::Stockpile.find params[:stockpile_id]
  end
end