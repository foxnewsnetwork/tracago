require 'spec_helper'

describe Itps::Drafts::PartiesController do
  login_user
  let(:draft) { controller.instance_variable_get :@draft }
  let(:current_account) { controller.send :current_account }
  describe '#update' do
    before do
      @draft = current_account.drafts.create_from_hash! buyer_email: 'asdf@fa.co'
      @params = {
        seller_company_name: 'Test Company Changed',
        seller_email: 'new_email@asdf.co',
        seller_address1: 'New Address',
        seller_city: 'New City',
        seller_province: 'New State',
        seller_country: 'New Country' 
      }
      @update = lambda { put :update, id: @draft.permalink, drafts: @params }
    end
    it 'should properly update the attributes' do
      @draft.parsed_hash.should eq buyer_email: 'asdf@fa.co'
      @update.call
      @draft.reload.parsed_hash.should eq @params.merge buyer_email: 'asdf@fa.co'
    end
    it 'should redirect to the next step of commodity' do
      @update.call
      response.should redirect_to Spree.r.edit_itps_draft_commodity_path draft.permalink
    end
  end
end  