class Itps::AdminBaseController < Itps::BaseController
  before_filter :filter_anonymous_account,
    :filter_wrong_account
end