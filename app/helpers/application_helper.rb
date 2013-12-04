module ApplicationHelper
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

end
