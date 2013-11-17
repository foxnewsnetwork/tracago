class Spree::Listings::ExceptionHandler
  def initialize(exception)
    @exception = exception
  end

  def flash_message
    return _errors_message if _model_errors?
    _default_message
  end

  private

  def _default_message
    Spree.t(:some_unknown_error_has_occured)
  end

  def _model_errors?
    @exception.is_a? ActiveModel::Errors
  end

  def _errors_message
    @exception.full_messages.join(", ")
  end
end