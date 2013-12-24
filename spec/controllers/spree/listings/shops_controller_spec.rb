require 'spec_helper'

describe Spree::Listings::ShopsController do
  describe "#new" do
    let(:spree_new) { spree_get :new, listing_id: @listing.id }
    before { @listing = ChineseFactory::Listing.mock }
    context 'logged out' do
      before do
        spree_new
      end
      let(:back_params) { controller.send :_back_params }
      it "should be a redirect" do
        response.response_code.should be 302
      end
      it "should redirect to the login path" do
        response.should redirect_to Spree.r.login_path back_params
      end 
    end

    context 'logged in' do
      login_user
      before do
        spree_new
      end
      it "should render successfully" do
        response.response_code.should eq 200
      end
    end
  end

  describe "#create" do
    let(:spree_create) { -> { spree_post :create, listing_id: @listing.id, shop: @params } }

    context 'logged out' do
      let(:back_params) { controller.send :_back_params }
      before do
        @listing = ChineseFactory::Listing.mock
      end
      it "should redirect to login" do
        spree_create.call
        response.should redirect_to Spree.r.login_path back_params
      end
    end

    context 'no listing' do
      before do
        @listing = OpenStruct.new.tap { |o| o.id = 28348234092834 }
      end
      it 'should render a 404' do
        spree_create.call
        response.response_code.should eq 404
      end
    end

    context 'missing picture' do
      login_user
      before do
        @params = {
          name: Faker::Name.name,
          email: Faker::Internet.email
        }
        @listing = ChineseFactory::Listing.mock
      end
      let(:shop_params) { controller.send :_raw_shop_params }
      it "should not create any images" do
        spree_create.should_not change(Spree::Image, :count)
      end
      it "should not alter the listing's shop" do
        shop_check = -> { @listing.reload.shop }
        spree_create.should_not change(shop_check, :call)
      end
      it "should not alter the listing's images" do
        image_check = -> { @listing.reload.images }
        spree_create.should_not change(image_check, :call)
      end
      it "should properly redirect back to this page" do
        spree_create.call
        response.should redirect_to Spree.r.new_listing_shop_path(@listing, shop_params)
      end
      it "should provide helpful flash message" do
        spree_create.call
        flash[:error].should =~ /image/i
      end
    end

    context 'success' do
      login_user
      before do
        @params = {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          images: [ChineseFactory::Image.mock, ChineseFactory::Image.mock]
        }
        @listing = ChineseFactory::Listing.mock
        @listing.update shop_id: nil
      end
      let(:current_user) { controller.send :current_user }
      it "should spawn a user who does not yet have a shop" do
        current_user.shop.should be_blank
      end
      it "should create two images" do
        spree_create.should change(Spree::Image, :count).by 2
      end
      it "should create a shop" do
        spree_create.should change(Spree::Shop, :count).by 1
      end
      it "should have attached the new shop to the appropriate user" do
        alcohol = -> { current_user.reload.shop }
        spree_create.should change(alcohol, :call).from nil
      end
      it "should attach the shop to the listing" do
        alcohol = -> { @listing.reload.shop }
        spree_create.should change(alcohol, :call).from nil
      end
      it "should redirect to the newly created listing" do
        spree_create.call
        response.should redirect_to Spree.r.listing_path @listing
      end
    end

    context "success - existing shop" do
      login_shop
      before do
        @params = {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          images: [ChineseFactory::Image.mock, ChineseFactory::Image.mock]
        }
        @listing = ChineseFactory::Listing.mock
        @listing.update shop_id: nil
      end
      let(:current_user) { controller.send :current_user }
      it "should have spawned a user with a shop" do
        current_user.shop.should be_a Spree::Shop
      end
      it "should create two images" do
        spree_create.should change(Spree::Image, :count).by 2
      end
      it "should not create a shop" do
        spree_create.should_not change(Spree::Shop, :count)
      end
      it "should change the value of name of the existing shop" do
        attribute_check = -> { current_user.shop.reload.name }
        spree_create.should change(attribute_check, :call).to @params[:name]
      end
      it "should change the value of email of the existing shop" do
        attribute_check = -> { current_user.shop.reload.email }
        spree_create.should change(attribute_check, :call).to @params[:email]
      end
      it "should attach the shop to the listing" do
        alcohol = -> { @listing.reload.shop }
        spree_create.should change(alcohol, :call).from nil
      end
      it "should redirect to the newly created listing" do
        spree_create.call
        response.should redirect_to Spree.r.listing_path @listing
      end
    end

  end
end