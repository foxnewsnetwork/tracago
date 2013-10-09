module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = ChineseFactory::User.mock
      sign_in user
    end
  end

  def login_shop
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      shop = ChineseFactory::Shop.mock
      sign_in shop.user
    end
  end
end