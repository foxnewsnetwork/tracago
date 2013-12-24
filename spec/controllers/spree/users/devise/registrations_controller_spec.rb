require 'spec_helper'

describe Spree::Users::Devise::RegistrationsController do
  describe "#create" do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }
    let(:spree_create) { -> { spree_post :create, user: @params } }
    let(:current_user) { controller.send :current_user }
    let(:back_params) { controller.send :_back_params }
    context "success - default" do
      before do
        @params = ChineseFactory::User.attributes
        @params[:password_confirmation] = @params[:password]
      end
      it "should successfully create a user" do
        spree_create.should change(Spree::User, :count).by(1)
      end
      it "should also login the user in" do
        login_check = -> { controller.send :user_signed_in? }
        spree_create.should change(login_check, :call).from(false).to true
      end
      it "should redirect to the location given in the back params" do
        spree_create.call
        response.should redirect_to Spree.r.user_path current_user
      end
    end
    context "success" do
      before do
        @params = ChineseFactory::User.attributes
        @params[:password_confirmation] = @params[:password]
        @params[:back] = Spree.r.new_listing_path
      end
      it "should successfully create a user" do
        spree_create.should change(Spree::User, :count).by(1)
      end
      it "should also login the user in" do
        login_check = -> { controller.send :user_signed_in? }
        spree_create.should change(login_check, :call).from(false).to true
      end
      it "should redirect to the location given in the back params" do
        spree_create.call
        response.should redirect_to @params[:back]
      end
    end
    context "email-collison failure" do
      before do
        @existing_user = ChineseFactory::User.mock
        @params = {
          email: @existing_user.email,
          password: "asdf123",
          password_confirmation: "asdf123"
        }
      end
      let(:new_user) { controller.send(:resource) }
      it 'should not generate a valid user' do
        spree_create.call
        new_user.should_not be_valid
      end
      it "should not create a new user" do
        spree_create.should_not change(Spree::User, :count)
      end
      it "should change the logged in state" do
        login_check = -> { controller.send :user_signed_in? }
        spree_create.should_not change(login_check, :call)
      end
      it "should redirect back to the sign up path" do
        spree_create.call
        response.should redirect_to Spree.r.signup_path back_params
      end
      it "should generate a flash message informing the user something is wrong" do
        spree_create.call
        flash[:error].should =~ /email/
      end
    end
    context "missing password confirmation" do
      before do 
        @params = ChineseFactory::User.attributes
        @params[:password_confirmation] = nil
      end
      it "should not create a new user" do
        spree_create.should_not change(Spree::User, :count)
      end
      it "should change the logged in state" do
        login_check = -> { controller.send :user_signed_in? }
        spree_create.should_not change(login_check, :call)
      end
      it "should redirect back to the sign up path" do
        spree_create.call
        response.should redirect_to Spree.r.signup_path back_params
      end
      it "should generate a flash message informing the user something is wrong" do
        spree_create.call
        flash[:error].should =~ /password/
      end
    end
  end
end  