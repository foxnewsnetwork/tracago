require 'spec_helper'

describe Spree::Users::RegistrationsController do
  describe "#new" do
    let(:spree_new) { spree_get :new, back: @back }
    context "simple usage" do
      before { spree_new }
      it "should render successfully" do
        response.response_code.should eq 200
      end
      it "should render the correct template" do
        response.should render_template("new")
      end
    end
    context "redirect logged in users" do
      login_user
      let(:current_user) { controller.send :current_user }
      before { spree_new }
      it "should redirect to the user's profile page if he is already logged in" do
        response.should redirect_to Spree.r.user_path current_user
      end
      it "should generate flash message informing the user he is already logged in" do
        flash[:notice].should =~ /in/
      end
    end
    context "redirect logged in users with back" do
      login_user
      let(:current_user) { controller.send :current_user }
      before do 
        @back = Spree.r.new_listing_path
        spree_new
      end
      it "should redirect to the user's profile page if he is already logged in" do
        response.should redirect_to @back
      end
      it "should generate flash message informing the user he is already logged in" do
        flash[:notice].should =~ /in/
      end
    end

  end
end