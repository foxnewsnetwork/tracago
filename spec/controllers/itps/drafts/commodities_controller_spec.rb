require 'spec_helper'

describe Itps::Drafts::CommoditiesController do
  login_user
  let(:draft) { controller.instance_variable_get :@draft }
  let(:current_account) { controller.send :current_account }
  let(:form_helper) { controller.send :_form_helper }
  describe '#update' do
    before do
      @draft = current_account.drafts.create_from_hash! buyer_email: 'asdf@fa.co'
      @update = lambda { put :update, id: @draft.permalink, drafts: @params }
    end
    let(:redraft) { @draft.reload }
    context 'good' do
      before do
        @params = {
          price_terms: 'FAS Long Beach',
          latest_shipment_date: 8.days.from_now.to_date.to_s,
          prices: [1,2,3,4],
          quantities: [1,2,3,4],
          items: ['pies','cakes','cookies','cream puffs']
        }
      end
      it 'should successfully update the draft object' do
        @update.call
        redraft.parsed_hash[:price_terms].should eq @params[:price_terms]
        redraft.parsed_hash[:latest_shipment_date].should eq @params[:latest_shipment_date]
        redraft.parsed_hash[:prices].map(&:to_i).should eq @params[:prices]
        redraft.parsed_hash[:quantities].map(&:to_i).should eq @params[:quantities]
        redraft.parsed_hash[:items].should eq @params[:items]
      end
      it 'should not have any errors' do
        @update.call
        form_helper.errors.full_messages.join(',').should eq ''
      end
      it 'should properly redirect to the next step' do
        @update.call
        response.should redirect_to Spree.r.edit_itps_draft_document_path(draft.permalink)
      end
    end
    context 'bad' do
      before do
        @params = {
          price_terms: 'FAS Long Beach',
          latest_shipment_date: 8.days.from_now.to_date.to_s,
          prices: [1,2,3,4,5],
          quantities: [1,2,3,4],
          items: ['pies','cakes','cookies','cream puffs']
        }
      end
      it 'should not create the draft object' do
        @update.call
        redraft.parsed_hash.keys.should_not include :price_terms
        redraft.parsed_hash.keys.should_not include :latest_shipment_date
        redraft.parsed_hash.keys.should_not include :prices
        redraft.parsed_hash.keys.should_not include :quantities
        redraft.parsed_hash.keys.should_not include :items
      end
    end
  end
end