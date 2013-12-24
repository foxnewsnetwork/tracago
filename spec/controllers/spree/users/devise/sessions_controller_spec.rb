require 'spec_helper'

describe Spree::Users::Devise::SessionsController do
  describe "#create" do
    before do 
      @user = ChineseFactory::User.mock
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    let(:spree_create) { spree_post :create, user: @params }
    let(:current_user) { controller.send :current_user }
    context "success" do
      before do
        @params = {
          email: @user.email,
          password: "asdf123"
        }
        spree_create
      end
      it "should correctly sign the user in" do
        current_user.should eq @user
      end
      it "should redirect to the root path by default" do
        response.should redirect_to Spree.r.root_path
      end
    end
    context "failure - redirect back" do
      before do
        @params = { 
          email: @user.email,
          password: "wrong-password",
          back: Spree.r.listings_path
        }
        spree_create
      end
      it "should redirect back to the sign-in path and maintain the same back path" do
        response.should redirect_to Spree.r.login_path( back: @params[:back] )
      end
      it "should not sign anyone in" do
        current_user.should be_blank
      end
    end
    context "failure - redirect back" do
      before do
        @params = { 
          email: @user.email,
          password: "wrong-password"
        }
        spree_create
      end
      it "should redirect back to the sign-in path and maintain the same back path" do
        response.should redirect_to Spree.r.login_path
      end
      it "should not sign anyone in" do
        current_user.should be_blank
      end
    end

    context "success - redirect" do
      before do
        @params = {
          email: @user.email,
          password: "asdf123",
          back: Spree.r.new_listing_path
        }
        spree_create
      end
      it "should still sign the user in" do
        current_user.should eq @user
      end
      it "should redirect to the back path as specified" do
        response.should redirect_to @params[:back]
      end
    end
  end
end