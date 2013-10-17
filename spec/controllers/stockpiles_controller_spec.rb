require 'spec_helper'

describe Spree::StockpilesController do
  before do
    @listing = ChineseFactory::Listing.mock
    @stockpile = @listing.stockpile
  end
  let(:listing) { ChineseFactory::Listing.belongs_to(@shop).mock }
  let(:current_user) { controller.send :current_user }

  describe "#destroy" do
    let(:spree_destroy) { -> { spree_delete :destroy, id: @stockpile.id } }
    context 'success' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
      end
      it "should destroy the stockpile" do
        spree_destroy.should change(Spree::Stockpile, :count).by -1
      end
      it "should destroy the assosicated listing" do
        spree_destroy.should change(Spree::Listing, :count).by -1
      end
      it "should setup a proper flash message" do
        spree_destroy.call
        flash[:notice].should =~ /removed/
      end
      it "should redirect to the root path" do
        spree_destroy.call
        response.should redirect_to Spree.r.root_path
      end
    end
    context 'failure - unknown reasons' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
        controller.stub!(:_destroy_stockpile!) { false }
      end
      it "should destroy the stockpile" do
        spree_destroy.should_not change(Spree::Stockpile, :count)
      end
      it "should destroy the assosicated listing" do
        spree_destroy.should_not change(Spree::Listing, :count)
      end
      it "should setup a proper flash message" do
        spree_destroy.call
        flash[:error].should =~ /wrong/
      end
      it "should redirect to the root path" do
        spree_destroy.call
        response.should redirect_to Spree.r.stockpile_path @stockpile
      end
    end
  end

  describe "#show" do
    context 'success' do
      before do
        spree_get :show, id: @stockpile.id
      end
      let(:accurate_title) { controller.send :accurate_title }
      it "should just be the name of the thing" do
        accurate_title.should eq @stockpile.name
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
    end
    context 'failure' do
      before do
        @stockpile = ChineseFactory::Stockpile.mock
        spree_get :show, id: @stockpile.id
      end
      it "should redirect to the home path" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash message" do
        flash[:error].should =~ /not ready/i
      end
    end
  end

  describe "#edit" do
    context 'success' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
        spree_get :edit, id: @stockpile.id
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
    end
    context 'failure - not logged in' do
      before do
        @shop = ChineseFactory::Shop.mock
        spree_get :edit, id: @stockpile.id
      end
      let(:owner) { controller.send(:_stockpile).owner }
      let(:correct_user_session?) { controller.send(:correct_user_session?, owner) }
      let(:fullpath) { request.fullpath }
      it "should be that the unlogged in user has not the correct user session" do
        correct_user_session?.should_not be_true
      end
      it "should redirect to the login path" do
        response.should redirect_to Spree.r.login_path back: request.fullpath
      end
      it "should show a flash message" do
        flash[:error].should =~ /in/
      end
    end
    context 'failure - wrong user' do
      login_shop
      before do
        @shop = ChineseFactory::Shop.mock
        @stockpile = listing.stockpile
        spree_get :edit, id: @stockpile.id
      end
      it "should redirect to the path of the stockpile" do
        response.should redirect_to Spree.r.stockpile_path @stockpile
      end
      it "should generate a flash message" do
        flash[:error].should =~ /owner/i
      end
    end
    context 'failure - incompleteness' do
      before do
        @stockpile = ChineseFactory::Stockpile.mock
        spree_get :edit, id: @stockpile.id
      end
      it "should redirect to the home path" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash message" do
        flash[:error].should =~ /not ready/i
      end
    end
  end

  describe "#edit_address" do
    context 'success' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
        spree_get :edit_address, id: @stockpile.id
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
    end
    context 'failure - not logged in' do
      before do
        @user = ChineseFactory::User.mock
        spree_get :edit, id: @stockpile.id
      end
      it "should redirect to the login path" do
        response.should redirect_to Spree.r.login_path back: request.fullpath
      end
      it "should show a flash message" do
        flash[:error].should =~ /in/
      end
    end
    context 'failure - wrong user' do
      login_shop
      before do
        @shop = ChineseFactory::Shop.mock
        @stockpile = listing.stockpile
        spree_get :edit_address, id: @stockpile.id
      end
      it "should redirect to the path of the stockpile" do
        response.should redirect_to Spree.r.stockpile_path @stockpile
      end
      it "should generate a flash message" do
        flash[:error].should =~ /owner/i
      end
    end
    context 'failure - incompleteness' do
      before do
        @stockpile = ChineseFactory::Stockpile.mock
        spree_get :edit_address, id: @stockpile.id
      end
      it "should redirect to the home path" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash message" do
        flash[:error].should =~ /not ready/i
      end
    end
  end

  describe "#edit_picture" do
    context 'success' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
        spree_get :edit_picture, id: @stockpile.id
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
    end
    context 'failure - not logged in' do
      before do
        @user = ChineseFactory::User.mock
        spree_get :edit_picture, id: @stockpile.id
      end
      it "should redirect to the login path" do
        response.should redirect_to Spree.r.login_path back: request.fullpath
      end
      it "should show a flash message" do
        flash[:error].should =~ /in/
      end
    end
    context 'failure - wrong user' do
      login_shop
      before do
        @shop = ChineseFactory::Shop.mock
        @stockpile = listing.stockpile
        spree_get :edit_picture, id: @stockpile.id
      end
      it "should redirect to the path of the stockpile" do
        response.should redirect_to Spree.r.stockpile_path @stockpile
      end
      it "should generate a flash message" do
        flash[:error].should =~ /owner/i
      end
    end
    context 'failure - incompleteness' do
      before do
        @stockpile = ChineseFactory::Stockpile.mock
        spree_get :edit_picture, id: @stockpile.id
      end
      it "should redirect to the home path" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash message" do
        flash[:error].should =~ /not ready/i
      end
    end
  end

  describe "#edit_sellers_offer" do
    context 'success' do
      login_shop
      before do
        @shop = current_user.shop
        @stockpile = listing.stockpile
        spree_get :edit_sellers_offer, id: @stockpile.id
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
    end
    context 'failure - not logged in' do
      before do
        @user = ChineseFactory::User.mock
        spree_get :edit_sellers_offer, id: @stockpile.id
      end
      it "should redirect to the login path" do
        response.should redirect_to Spree.r.login_path back: request.fullpath
      end
      it "should show a flash message" do
        flash[:error].should =~ /in/
      end
    end
    context 'failure - wrong user' do
      login_shop
      before do
        @shop = ChineseFactory::Shop.mock
        @stockpile = listing.stockpile
        spree_get :edit_sellers_offer, id: @stockpile.id
      end
      it "should redirect to the path of the stockpile" do
        response.should redirect_to Spree.r.stockpile_path @stockpile
      end
      it "should generate a flash message" do
        flash[:error].should =~ /owner/i
      end
    end
    context 'failure - incompleteness' do
      before do
        @stockpile = ChineseFactory::Stockpile.mock
        spree_get :edit_sellers_offer, id: @stockpile.id
      end
      it "should redirect to the home path" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash message" do
        flash[:error].should =~ /not ready/i
      end
    end
  end

end