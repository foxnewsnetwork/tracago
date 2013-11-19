# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
# Spree.config do |config|
#   # Example:
#   # Uncomment to override the default site name.
#   # config.site_name = "Spree Demo Site"
# end

# Spree.user_class = "Spree::User"
module Spree
  Config = { 
    address_requires_state: true,
    attachment_styles: "{\"mini\":\"48x48>\",\"small\":\"100x100>\",\"product\":\"240x240>\",\"large\":\"600x600>\"}",
    attachment_path: ":rails_root/public/spree/products/:id/:style/:basename.:extension",
    attachment_url: "/spree/products/:id/:style/:basename.:extension",
    attachment_default_url: "/spree/products/:id/:style/:basename.:extension",
    attachment_default_style: "product"
  }
  class << self
    def r
      @_route_debugger ||= Spree::RouteDebugger.new
    end

    def t(*args)
      I18n.t *args
    end
  end

  class RouteDebugger
    include Rails.application.routes.url_helpers
    # include Spree::Core::Engine.routes.url_helpers
  end
end

class ActiveRecord::Base
  class << self
    
    def compute_table_name_with_spree
      prefixes = self.to_s.split("::")
      if 1 == prefixes.count 
        compute_table_name_without_spree
      else
        prefixes.map(&:underscore).join("_").pluralize
      end
    end
    alias_method_chain :compute_table_name, :spree
  end
end