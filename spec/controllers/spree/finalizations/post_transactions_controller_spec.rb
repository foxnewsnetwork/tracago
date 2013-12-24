require 'spec_helper'

describe Spree::Finalizations::PostTransactionsController do
  describe '#create' do
    login_shop
    let(:buyer) { controller.send :current_shop }
    let(:offer) { ChineseFactory::Offer.belongs_to(buyer).mock }
    let(:finalization) { ChineseFactory::Finalization.belongs_to(offer).mock }
    let(:spree_create) { -> { spree_post :create, finalization_id: finalization.id } }

    it 'should create a post_transaction' do
      spree_create.should change(Spree::PostTransaction, :count).by 1
    end

    it 'should change the finalization from incomplete to tru' do
      f = -> { finalization.reload.shitty? }
      spree_create.should change(f, :call).from(false).to(true)
    end

    it 'should post_transaction from blank to existing' do
      f = -> { finalization.reload.post_transaction }
      spree_create.should change(f, :call).from(nil)
    end
  end

  describe '#new' do
    login_shop
    let(:buyer) { controller.send :current_shop }
    let(:offer) { ChineseFactory::Offer.belongs_to(buyer).mock }
    let(:finalization) { ChineseFactory::Finalization.belongs_to(offer).mock }
    before do
      spree_get :new, finalization_id: finalization.id
    end
    it 'should have the buyer be the same as the current person' do
      buyer.should eq finalization.buyer
    end
    it 'should not be the seller' do
      buyer.should_not eq finalization.seller
    end
    it 'should render correctly' do
      response.should render_template "new"
    end
    it 'should be okay' do
      response.response_code.should eq 200
    end
  end

  describe '#new - wrong user' do
    login_shop
    let(:finalization) { ChineseFactory::Finalization.mock }
    before do
      spree_get :new, finalization_id: finalization.id
    end
    it 'should redirect' do
      response.should redirect_to Spree.r.root_path
    end
    it 'should be 302' do
      response.response_code.should eq 302
    end
    it 'should do flash' do
      flash[:error].should =~ /in/
    end
  end

  describe '#new - anonymous user' do
    let(:finalization) { ChineseFactory::Finalization.mock }
    before do
      spree_get :new, finalization_id: finalization.id
    end
    it 'should redirect' do
      response.should redirect_to Spree.r.login_path back: request.fullpath
    end
    it 'should be 302' do
      response.response_code.should eq 302
    end
    it 'should do flash' do
      flash[:error].should =~ /in/
    end
  end
end