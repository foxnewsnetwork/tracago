require 'spec_helper'

describe Spree::OffersController do
  let(:current_user) { controller.send(:current_user) }
  let(:current_shop) { current_user.shop}
  describe "#edit" do
    let(:spree_edit) { spree_get :edit, id: @offer.id }
    context "success" do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(current_shop).mock
        spree_edit
      end
      let(:actual_shop) { controller.send :_correct_shop }
      it "should match the shops against each other" do
        current_shop.should eq actual_shop
      end
      it "should render successfully" do
        response.response_code.should eq 200
      end
    end
    context "redirect - anonymous" do
      before do
        @offer = ChineseFactory::Offer.mock
        spree_edit
      end
      it "should redirect to the signin page" do
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it "should generate flash" do
        flash[:error].should =~ /in/
      end
    end
    context 'redirect - 404' do
      login_shop
      before do
        @offer = OpenStruct.new { |o| o.id = 23840283492 }
        spree_edit
      end
      it "should 404" do
        response.response_code.should eq 404
      end
    end
    context 'redirect - wrong' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.mock
        spree_edit
      end
      it "should redirect to the root" do
        response.should redirect_to Spree.r.root_path
      end
      it "should generate flash" do
        flash[:error].should =~ /us/
      end
    end
  end

  describe "#update" do
    let(:spree_update) { -> {spree_put :update, id: @offer.id, offer: @params } }
    let(:current_user) { controller.send :current_user }
    let(:current_shop) { current_user.shop }
    context 'success' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(current_shop).mock
        @params = {
          minimum_pounds_per_load: rand(3454),
          transport_method: Spree::Offer::TransportMethods.random,
          usd_per_pound: (rand(544) / 1000.to_f),
          shipping_terms: Spree::Offer::Terms.random,
          expires_at: rand(42422).days.from_now,
          address1: Faker::AddressUS.street_address,
          address2: Faker::AddressUS.secondary_address,
          city: Faker::AddressUS.city,
          zipcode: Faker::AddressUS.zip_code,
          country: ChineseFactory::Country.mock.id,
          state: ChineseFactory::State.mock.id
        }
      end
      it "should be a valid offer" do
        @offer.should be_a Spree::Offer
        @offer.id.should be_present
      end
      Spree::Offers::ParamsProcessor::OfferFields.each do |key|
        it "should change the attribute under the key #{key}" do
          change_checker = -> { @offer.reload.send(key).to_s }
          spree_update.call
          change_checker.call.should eq @params[key].to_s
        end
      end
      it "should properly have changed the address" do
        change_checker = -> { @offer.reload.address.reload }
        spree_update.should change(change_checker, :call)
      end
      it "should have created a new address" do
        spree_update.should change(Spree::Address, :count).by 1
      end
      [:address1, :address2, :city, :zipcode].each do |key|
        it "should now match the new addresses on key #{key}" do
          change_checker = -> { @offer.reload.address.send(key).to_s }
          spree_update.call
          change_checker.call.should eq @params[key].to_s
        end
      end
      it "should have changed the state" do
        spree_update.call
        @offer.reload.address.state.id.should eq @params[:state]
      end
      it "should have changed the country" do
        spree_update.call
        @offer.reload.address.country.id.should eq @params[:country]
      end
    end
    context 'render failure' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(current_shop).mock
        @params = { country: "Nonexistland" }
      end
      it "should not change the offer" do
        change_checker = -> { @offer.reload }
        spree_update.should_not change(change_checker, :call)
      end
      it "should not change the address" do
        change_checker = -> { @offer.reload.address }
        spree_update.should_not change(change_checker, :call)
      end
      it "should not create any addresses" do
        spree_update.should_not change(Spree::Address, :count)
      end
      it "should render the edit page" do
        spree_update.call
        response.should render_template "edit"
      end
      it "should present a resonable flash" do
        spree_update.call
        flash[:error].should =~ /wrong/
      end
    end
    context 'redirect login' do
      before do
        @offer = ChineseFactory::Offer.mock
        @params = { dog: 1, cat: 2 }
      end
      it "should redirect on account that we don't have permission" do
        spree_update.call
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it "should render a correct flash message" do
        spree_update.call
        flash[:error].should =~ /in/
      end
      it "should not change the offer" do
        offer_check = -> { @offer.reload }
        spree_update.should_not change(offer_check, :call)
      end
      it "should not change the offer address" do
        offer_check = -> { @offer.reload.address }
        spree_update.should_not change(offer_check, :call)
      end
    end
  end

  describe "#show" do
    let(:spree_show) { spree_get :show, id: @offer.id }  
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