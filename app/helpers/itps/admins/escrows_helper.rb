module Itps::Admins::EscrowsHelper
  
  def activate_class_name_for_this_page(name='')
    return 'active' if name.to_s == params[:q].to_s
    return 'inactive'
  end

  def append_query_to_path_for_this_page(query)
    itps_admin_escrows_path(q: query)
  end
end