class Itps::BaseController < ApplicationController
  layout 'itps/layouts/application'
  include Itps::BaseHelper
  include Itps::SessionsHelper
end