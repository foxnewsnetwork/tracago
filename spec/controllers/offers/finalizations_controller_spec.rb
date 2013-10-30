require 'spec_helper'

describe Spree::Offers::FinalizationsController do
  describe 'create' do
    let(:spree_create) { -> {spree_post :create, offer_id: @offer.id, finalization: @params} }
    let(:current_shop) { controller.send :current_shop }
    let(:finalization) { controller.instance_variable_get :@finalization }
    context 'success' do
      login_shop
      before do
        @listing = ChineseFactory::Listing.belongs_to(current_shop).mock
        @offer = ChineseFactory::Offer.belongs_to(@listing).mock
        @params = {
          expires_at: 10.days.from_now
        }
      end
      it 'should create a finalization' do
        spree_create.should change(Spree::Finalization, :count).by 1
      end
      it 'should change the state of the offer' do
        state_check = -> { @offer.reload.accepted? }
        spree_create.should change(state_check, :call)
      end
      it 'should redirect to the finalization' do
        spree_create.call
        response.should redirect_to Spree.r.finalization_path finalization
      end
    end
    context 'failure-unacceptable' do
      login_shop
      before do
        @listing = ChineseFactory::Listing.belongs_to(current_shop).mock
        @offer = ChineseFactory::Offer.belongs_to(@listing).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        @params = {
          expires_at: 10.days.from_now
        }
      end
      it 'should not create a finalization' do
        spree_create.should_not change(Spree::Finalization, :count)
      end
      it 'should not change the state of the offer' do
        state_check = -> { @offer.reload.accepted? }
        spree_create.should_not change(state_check, :call)
      end
      it 'should render flash' do
        spree_create.call
        flash[:error].should =~ /ac/
      end
      it 'should render new' do
        spree_create.call
        response.should render_template "new"
      end
    end
    context 'redirect' do
      before do
        @offer = ChineseFactory::Offer.mock
      end
      it 'should not create anything' do 
        spree_create.should_not change(Spree::Finalization, :count)
      end
      it 'should redirect' do
        spree_create.call
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it 'should render flash' do
        spree_create.call
        flash[:error].should =~ /in/
      end
    end
    context 'wrong user' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.mock
      end
      it 'should not create anything' do 
        spree_create.should_not change(Spree::Finalization, :count)
      end
      it 'should redirect' do
        spree_create.call
        response.should redirect_to Spree.r.root_path
      end
      it 'should render flash' do
        spree_create.call
        flash[:error].should =~ /in/
      end
    end
  end
  describe 'new' do
    let(:spree_new) { spree_get :new, offer_id: @offer.id }
    context 'redirect' do
      before do
        @offer = ChineseFactory::Offer.mock
        spree_new
      end
      it 'should redirect' do
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it 'should render flash' do
        flash[:error].should =~ /in/
      end
    end
    context 'wrong user' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.mock
        spree_new
      end
      it 'should redirect' do
        response.should redirect_to Spree.r.root_path
      end
      it 'should render flash' do
        flash[:error].should =~ /in/
      end
    end
    context 'correct' do
      login_shop
      let(:current_shop) { controller.send :current_shop }
      before do
        @listing = ChineseFactory::Listing.belongs_to(current_shop).mock
        @offer = ChineseFactory::Offer.belongs_to(@listing).mock
        spree_new
      end
      it 'should render correctly' do
        response.response_code.should eq 200
      end
      it 'should not render flash' do
        flash[:error].should be_blank
      end
    end
  end
end