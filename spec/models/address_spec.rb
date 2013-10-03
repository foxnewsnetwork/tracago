require 'spec_helper'

describe Spree::Address do

  describe "#roughup_params" do
    let(:params) { Spree::Address.roughup_params @params } 
    before do
      @params = ChineseFactory::Address.new.attributes
    end
    it "the mocked country and state should have proper ids" do
      @params[:state].id.should be_present
      @params[:country].id.should be_present
    end
    it "should properly map the state and country from their ids to their actual thing" do
      @params[:state].class.should eq Spree::State
      @params[:country].class.should eq Spree::Country
      @params[:state] = @params[:state].id
      @params[:country] = @params[:country].id
      params[:state].should be_blank
      params[:country].should be_blank
      params[:state_id].should eq @params[:state]
      params[:country_id].should eq @params[:country]
    end
  end

  describe "#find_or_create_by" do
    before do
      @address = ChineseFactory::Address.new.attributes
    end
    let(:address) { Spree::Address.find_or_create_by @address }
    it "should create a new address" do
      expect { address }.to change(Spree::Address, :count).by(1)
    end
  end
end