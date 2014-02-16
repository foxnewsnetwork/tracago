class Admin::BaseController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
  layout 'admin/layouts/application'
end