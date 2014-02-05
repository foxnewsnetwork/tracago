require 'spec_helper'

describe Itps::Admins::InboundTransfersController do
  describe '#create' do
    login_user
    let(:current_account) { controller.send :current_account }
    before do
      current_account.adminify!
      @params = {
        account_number: '66666666',
        routing_number: '66666666',
        dollar_amount: 124134,
        memo: 'this is a test'
      }
      @create = lambda { post :create, inbound_transfers: @params }
    end
    it 'should create a money transfer' do
      @create.should change(Itps::MoneyTransfer, :count).by 1
    end
    it "should create a bank account since we don't have one yet" do
      @create.should change(Itps::Parties::BankAccount, :count).by 1
    end
  end
end