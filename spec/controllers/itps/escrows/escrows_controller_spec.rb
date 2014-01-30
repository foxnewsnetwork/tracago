require 'spec_helper'

describe Itps::Escrows::EscrowsController do
  describe '#create' do
    login_user
    let(:current_account) { controller.send :current_account }
    let(:escrow) { controller.send :_escrow }
    before do
      @party = current_account.party
      @escrow = JewFactory::Escrow.belongs_to(@party).create
      10.times { JewFactory::Escrows::Step.belongs_to(@escrow).create }
      @escrow_params = {
        other_party_email: Faker::Internet.email,
        other_party_company_name: Faker::Company.name,
        my_role: 'payment_party'
      }
      @create = lambda { post :create, escrow_id: @escrow.permalink, escrows: @escrow_params }
    end
    it 'should be properly created' do
      @escrow.should be_a Itps::Escrow
    end
    it 'should have 10 steps' do
      @escrow.steps.count.should eq 10
      @escrow.steps.each do |step|
        step.should be_a Itps::Escrows::Step
      end
    end
    it 'should belong to the proper party' do
      @escrow.draft_party.should eq @party
      @escrow.payment_party.should eq @party
    end
    it 'should properly create an escrow with 10 steps in it' do
      @create.call
      flash[:error].should be_blank
      flash[:success].should be_present
      response.should redirect_to Spree.r.itps_escrow_path(escrow.permalink)
    end
    it 'should have matching steps on the newly created escrow' do
      @create.call
      cloned = escrow.steps.map { |step| [step.title, step.instructions ] }
      original = @escrow.reload.steps.map { |step| [step.title, step.instructions] }
      cloned.should eq original
    end
  end
end