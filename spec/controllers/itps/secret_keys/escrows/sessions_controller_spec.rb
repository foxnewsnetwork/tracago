require 'spec_helper'

describe Itps::SecretKeys::Escrows::SessionsController do
  describe '#new' do
    before do
      @escrow = JewFactory::Escrow.mock
      @escrow.payment_party_agrees!
      @secret_key = @escrow.service_party_agree_key
    end
    let(:new_params) { { secret_key_id: @secret_key, escrow_id: @escrow.permalink } }
    context 'no account yet' do
      before do 
        get :new, new_params
      end
      specify { response.should redirect_to Spree.r.new_itps_secret_key_escrow_registration_path(@secret_key, @escrow.permalink) }
    end

    context 'account already exists' do
      before do
        Spree::User.create! email: @escrow.service_party.email, 
          password: '13413413413asdf', 
          password_confirmation: '13413413413asdf'
        get :new, new_params
      end
      specify { response.should be_success }
    end

    context 'already logged in' do
      login_user
      before do
        get :new, new_params
      end
      specify { response.should redirect_to Spree.r.new_itps_escrow_agreement_path(@escrow.permalink) }
    end
  end
end