module ApplicationHelper
  def company_legal_name
    "Global Payment Services Inc."
  end

  def main_content_div_id
    cpath = request.path_parameters[:controller]
    action = request.path_parameters[:action]
    cpath.split("/").push(action).tail.join "-"
  end

  def this_is_the_login_page?
    "spree/users/sessions" == request.path_parameters[:controller] &&
    "new" == request.path_parameters[:action].to_s
  end

  def this_is_the_signup_page?
    "spree/users/registrations" == request.path_parameters[:controller] &&
    "new" == request.path_parameters[:action].to_s
  end

  def this_is_the_itps_login_page?
    "itps/accounts/sessions" == request.path_parameters[:controller] &&
    "new" == request.path_parameters[:action].to_s
  end

  def this_is_the_itps_signup_page?
    _itps_signup_page? || _itps_signup_fail_page?
  end

  private
  def _itps_signup_page?
    "itps/accounts/registrations" == request.path_parameters[:controller] &&
    "new" == request.path_parameters[:action].to_s
  end

  def _itps_signup_fail_page?
    "itps/accounts/registrations" == request.path_parameters[:controller] &&
    "create" == request.path_parameters[:action].to_s
  end

end
