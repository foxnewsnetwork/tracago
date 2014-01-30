require 'spec_helper'

describe Itps::Escrows::DeleteController do
  describe '#destroy' do
    login_user
    let(:current_account) { controller.send :current_account }
    before do
      @party = current_account.party
      @escrow = JewFactory::Escrow.belongs_to(@party).create
      @destroy = lambda { delete :destroy, id: @escrow.permalink }
    end
    it 'should properly delete the escrow' do
      @destroy.should change(Itps::Escrow, :count).by(-1)
    end
    it 'should render flash and redirect' do
      @destroy.call
      flash[:success].should =~ /des/
      response.should redirect_to Spree.r.itps_account_path(current_account)
    end
  end
end