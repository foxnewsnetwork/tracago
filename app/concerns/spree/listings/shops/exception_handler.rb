class Spree::Listings::Shops::ExceptionHandler
  def initialize(e)
    @exception = e
  end

  def user_input_error?
    _missing_images?
  end

  def flash_message
    return _missing_images_message if _missing_images?
    _default_message
  end

  private

  def _default_message
    @exception.message
  end

  def _missing_images_message
    Spree.t(:you_need_to_upload_at_least_one_valid_image)
  end

  def _missing_images?
    _missing_key_error? && _default_message =~ /image/i
  end

  def _missing_key_error?
    @exception.is_a? Hash::EnforcedKeyMissing
  end
end