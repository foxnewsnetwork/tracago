class Spree::Finalizations::PostTransactionsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include Spree::UserFilterHelper
  before_filter :filter_anonymous_users, :filter_incorrect_users

  def new
    _finalization
  end

  def create
    _create_post_transaction!
    _setup_flash!
    _get_out_of_here!
  end

  private

  def _correct_shop
    _finalization.buyer
  end

  def _create_post_transaction! 
    @post_transaction ||= Spree::PostTransaction.create! _post_transaction_params if _valid?
  end

  def _post_transaction_params
    _form_helper.post_transaction_params.merge finalization: _finalization
  end

  def _finalization
    @finalization ||= Spree::Finalization.find params[:finalization_id]
  end

  def _valid?
    _form_helper.valid?
  end

  def _error_message
    _form_helper.errors.full_messages.join(", ")
  end

  def _form_helper
    @form_helper ||= Spree::Finalizations::PostTransactions::FormHelper.new _raw_post_transaction_params
  end

  def _raw_post_transaction_params
    {}
  end

  def _post_transaction
    @post_transaction ||= _create_post_transaction!
  end

  def _setup_flash! 
    flash[:error] = _error_message unless _valid?
  end

  def _get_out_of_here! 
    return redirect_to post_transaction_path _post_transaction if _valid?
    render :new
  end
end