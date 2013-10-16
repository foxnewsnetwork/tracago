require 'spec_helper'

describe Spree::User do
  describe "#email" do
    before do
      @user = ChineseFactory::User.mock
      @user2 = Spree::User.new email: @user.email, 
        password: "123asdf", 
        password_confirmation: "123asdf"
    end
    it "should be persisted" do
      @user.should be_persisted
    end
    it "the original user should be valid" do
      @user.should be_valid
    end
    it "should be invalid" do
      @user2.should_not be_valid
      @user2.errors.full_messages.join(",").should =~ /email/i
    end
  end  
end