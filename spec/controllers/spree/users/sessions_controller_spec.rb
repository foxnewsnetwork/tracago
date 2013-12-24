require 'spec_helper'

describe Spree::Users::SessionsController do
  describe "#new" do
    let(:spree_new) { -> { spree_get :new, back: @back } }
    context "simple usage" do
      before { spree_new.call }
      it "should successfully render the page" do
        response.response_code.should eq 200
      end
      it "should render the correct template" do
        response.should render_template "new"
      end
    end
    context "filtering logged in users" do
      login_user
      before { spree_new.call }
      let(:current_user) { controller.send :current_user }
      it "should redirect the user to his profile page by default" do
        response.should redirect_to Spree.r.user_path current_user
      end
      it "should generate a flash that says he is already logged in" do
        flash[:notice].should =~ /in/
      end
    end
    context "filtering logged in users with back" do
      login_user
      before do 
        @back = Spree.r.new_listing_path
        spree_new.call
      end
      let(:current_user) { controller.send :current_user }
      it "should redirect the user to his profile page by default" do
        response.should redirect_to @back
      end
      it "should generate a flash that says he is already logged in" do
        flash[:notice].should =~ /in/
      end
    end
  end
end