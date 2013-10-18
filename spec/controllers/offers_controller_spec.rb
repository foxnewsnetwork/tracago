require 'spec_helper'

describe Spree::OffersController do
  describe "#show" do
    let(:spree_show) { spree_get :show, id: @offer.id }
    let(:current_user) { controller.send(:current_user) }
    let(:current_shop) { current_user.shop}
    let(:relevant_user) { controller.send :relevant_user? }
    let(:seller_user) { controller.send :seller_user? }
    let(:buyer_user) { controller.send :buyer_user? }
    context "success" do
      before do
        @offer = ChineseFactory::Offer.mock
        spree_show
      end
      it "should render correctly" do
        response.response_code.should eq 200
      end
      it "should not relevant anymore" do
        relevant_user.should be_false
      end
    end
    context 'seller sessions' do
      login_shop
      before do
        @listing = ChineseFactory::Listing.belongs_to(current_shop).mock
        @offer = ChineseFactory::Offer.belongs_to(@listing).mock
        spree_show
      end
      it "should still be relevant" do
        relevant_user.should be_true
      end
      it "should not be the buyer" do
        buyer_user.should be_false
      end
      it "should be the seller" do
        seller_user.should be_true
      end
    end
    context 'buyer sessions' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(current_shop).mock
        spree_show
      end
      it "should be a relevant user" do
        relevant_user.should be_true
      end
      it "should be the proper buyer user" do
        buyer_user.should be_true
      end
      it "should not be the seller user" do
        seller_user.should be_false
      end
    end
    context "failure" do
      before do
        @offer = OpenStruct.new.tap { |o| o.id = 2084028450245 }
        spree_show
      end
      it "should render 404" do
        response.response_code.should eq 404
      end
    end
  end
end