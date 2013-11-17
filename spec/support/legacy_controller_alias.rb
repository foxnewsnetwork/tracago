module LegacyControllerAlias
  def spree_get(action, parameters = nil, session = nil, flash = nil)
    process_spree_action(action, parameters, session, flash, "GET")
  end

  # Executes a request simulating POST HTTP method and set/volley the response
  def spree_post(action, parameters = nil, session = nil, flash = nil)
    process_spree_action(action, parameters, session, flash, "POST")
  end

  # Executes a request simulating PUT HTTP method and set/volley the response
  def spree_put(action, parameters = nil, session = nil, flash = nil)
    process_spree_action(action, parameters, session, flash, "PUT")
  end

  # Executes a request simulating DELETE HTTP method and set/volley the response
  def spree_delete(action, parameters = nil, session = nil, flash = nil)
    process_spree_action(action, parameters, session, flash, "DELETE")
  end

  def spree_xhr_get(action, parameters = nil, session = nil, flash = nil)
    parameters ||= {}
    parameters.reverse_merge!(:format => :json)
    parameters.merge!(:use_route => :spree)
    xml_http_request(:get, action, parameters, session, flash)
  end

  private

  def process_spree_action(action, parameters = nil, session = nil, flash = nil, method = "GET")
    parameters ||= {}
    process(action, method, parameters, session, flash)
  end
end