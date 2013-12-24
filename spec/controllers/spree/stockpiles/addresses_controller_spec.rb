require 'spec_helper'


describe Spree::Stockpiles::AddressesController do
  describe "#new" do
    let(:spree_new) { -> { spree_get :new, stockpile_id: @stockpile.id } }
    let(:listing) { ChineseFactory::Listing.mock }
    context 'redirect' do
      before { @stockpile = listing.stockpile }
      it "should immediate redirect the user to the next step if we already have an address" do
        spree_new.call
        response.should redirect_to Spree.r.new_listing_shop_path listing
      end
    end
    context 'success' do
      before do
        @stockpile = Spree::Stockpile.find listing.stockpile
        @stockpile.update address_id: nil
      end
      it "should have a blank address" do
        @stockpile.should be_require_address
      end
      it "should render successfully" do
        spree_new.call
        response.response_code.should eq 200
      end
    end
  end

  describe "#create" do
    let(:spree_create) { -> { spree_post :create, stockpile_id: @stockpile.id, address_form_helper: @address } }
    context 'redirect' do
      before do
        @listing = ChineseFactory::Listing.mock
        @stockpile = Spree::Stockpile.find @listing.stockpile
      end
      it "should not create an address" do
        spree_create.should_not change(Spree::Address, :count)
      end
      it 'should not change the attached address' do
        spree_create.should_not change(@stockpile, :address_id)
      end
      it "should redirect to the next step" do
        spree_create.call
        response.should redirect_to Spree.r.new_listing_shop_path @listing
      end
    end
    context 'success' do
      before do
        @listing = ChineseFactory::Listing.mock
        @stockpile = Spree::Stockpile.find(@listing.stockpile)
        @stockpile.update address_id: nil
        @address = ChineseFactory::Address.attributes.access_map! :state, :country, &:id
      end
      it "should create a new address" do
        spree_create.should change(Spree::Address, :count).by(1)
      end
      it "should un-nil the address_id" do
        thing = -> { @stockpile.reload.address }
        spree_create.should change(thing, :call).from(nil)
      end
      it "should summarily redirect to the next step of specifying the shop" do
        spree_create.call
        response.should redirect_to Spree.r.new_listing_shop_path @listing
      end
    end
    context 'failure - bad stockpile' do
      before do
        @stockpile = OpenStruct.new.tap { |o| o.id = 238490238490285902345 }
      end
      it "should not change anything" do
        spree_create.should_not change(Spree::Address, :count)
      end
      it "should render a 404" do
        spree_create.call
        response.response_code.should eq 404
      end
    end
    context 'failure - missing address1' do
      before do
        @listing = ChineseFactory::Listing.mock
        @stockpile = Spree::Stockpile.find(@listing.stockpile)
        @stockpile.update address_id: nil
        @address = ChineseFactory::Address.attributes.access_map! :state, :country, &:id
        @address.delete :address1
      end
      let(:address_params) { controller.send :_address_params }
      it "should not create a new address" do
        spree_create.should_not change(Spree::Address, :count)
      end
      it "should not change the stockpile's nil address" do
        thing = -> { @stockpile.reload.address }
        spree_create.should_not change(thing, :call)
      end
      it "should redirect back to this very page" do
        spree_create.call
        response.should render_template("new")
      end
      it "should feature the correct flash message" do
        spree_create.call
        flash[:error].should =~ /address/i
      end
    end
  end

end
