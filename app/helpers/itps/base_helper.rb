module Itps::BaseHelper
  class << self
    def itps_app_host
      'globaltradepayment.co'
    end
  end
  def back_path
    if this_is_the_itps_login_page? || this_is_the_itps_signup_page?
      back_path = params[:back]
    else
      request.fullpath
    end
  end

end