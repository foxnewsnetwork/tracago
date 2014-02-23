require 'spec_helper'

describe Itps::Buys::InternationalsController do
  login_user
  let(:draft) { controller.instance_variable_get :@draft }
  let(:current_account) { controller.send :current_account }
  describe '#update' do
    before do
      @original_params = {
        buyer_company_name: 'Test Company',
        buyer_email: 'old_email@asdf.co',
        buyer_address1: 'Old Address',
        buyer_city: 'Old City',
        buyer_province: 'Old State',
        buyer_country: 'Old Country'
      }
      @params = {
        buyer_company_name: 'Test Company Changed',
        buyer_email: 'new_email@asdf.co',
        buyer_address1: 'New Address',
        buyer_city: 'New City',
        buyer_province: 'New State',
        buyer_country: 'New Country' 
      }
      @draft = current_account.drafts.create_from_hash! @original_params
      @update = lambda { put :update, id: @draft.permalink, drafts: @params }
    end
    it 'should properly update the draft object' do
      @draft.parsed_hash.should eq @original_params
      @update.call
      @draft.reload.parsed_hash.should eq @params
    end
    it 'should properly redirect to the next step' do
      @update.call
      response.should redirect_to Spree.r.edit_itps_draft_party_path(draft.permalink)
    end
  end

  describe '#create' do
    before do
      @create = lambda { post :create, drafts: @draft }
    end
    context 'good' do
      before do
        @draft = {
          buyer_company_name: 'Test Company',
          buyer_address1: Faker::Address.street_address,
          buyer_city: Faker::Address.city,
          buyer_province: Faker::AddressUS.state,
          buyer_country: Faker::Address.country
        }
      end
      it 'should create a draft object' do
        @create.should change(Itps::Draft, :count).by 1
      end
      it 'should go to the next step which is the party page' do
        @create.call
        response.should redirect_to Spree.r.edit_itps_draft_party_path(draft.permalink)
      end
    end
    context 'bad' do
      before do
        @draft = {
          buyer_company_name: 'Test Company'
        }
      end
      it 'should not create a draft object' do
        @create.should_not change(Itps::Draft, :count)
      end
      it 'should render new' do
        @create.call
        response.should render_template 'new'
      end
    end
  end
end