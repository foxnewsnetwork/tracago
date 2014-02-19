require 'spec_helper'

describe Itps::SecretKeys::Escrows::AgreementsController do
  context 'the drafting party has finished and wants the other party to agree' do
    before do
      @escrow = JewFactory::Escrow.mock
      @escrow.payment_party_agrees!
    end
    describe '#show' do
      let(:get_params) { { secret_key_id: @secret_key, escrow_id: @escrow.permalink } }
      context 'correct secret key' do
        before do
          @secret_key = @escrow.service_party_agree_key
          get :new, get_params
        end
        it 'should properly render the agreement page' do
          response.should be_success
        end
      end
      context 'wrong secret key' do
        before do
          @secret_key = 'not_the_right_key'
          get :new, get_params
        end
        it 'should redirect to the vanilla escrow page' do
          response.should redirect_to Spree.r.itps_escrow_path(@escrow.permalink)
        end
        it 'should generate a flash message' do
          flash[:notice].should be_present
        end
      end
      context 'irrelevant user' do
        login_user
        before do
          @secret_key = @escrow.service_party_agree_key
          get :new, get_params
        end
        it 'should redirect to the vanilla escrow page' do
          response.should redirect_to Spree.r.itps_escrow_path(@escrow.permalink)
        end
        it 'should flash' do
          flash[:notice].should be_present
        end
      end
      context 'relevant user' do
        login_user
        let(:current_account) { controller.send :current_account }
        before do
          @escrow.update service_party: current_account.party
          @secret_key = @escrow.service_party_agree_key
          get :new, get_params
        end
        it 'should redirect to the vanilla escrow agreement page' do
          response.should redirect_to Spree.r.new_itps_escrow_agreement_path(@escrow.permalink)
        end
      end
    end
  end
end