require 'spec_helper'

describe Spree::Finalizations::Serviceables::Trucks::FormHelper do
  it_should_behave_like "ActiveModel"
  let(:form_helper) { Spree::Finalizations::Serviceables::Trucks::FormHelper.new @params }
  before do
    @start = ChineseFactory::Address.mock
    @finish = ChineseFactory::Address.mock
    @params = {
      start_address1: @start.address1,
      start_address2: @start.address2,
      start_city: @start.city,
      start_state: @start.state.id,
      start_country: @start.country.id,
      start_zipcode: @start.zipcode,
      finish_address1: @finish.address1,
      finish_address2: @finish.address2,
      finish_city: @finish.city,
      finish_state: @finish.state.id,
      finish_country: @finish.country.id,
      finish_zipcode: @finish.zipcode,
      pickup_at: 10.days.from_now,
      arrive_at: 15.days.from_now,
      usd_price: 23842
    }
  end
  describe '#_core_hash' do
    let(:core) { form_helper.send :_core_hash }
    it 'should match on pickup_at' do
      core[:pickup_at].should eq @params[:pickup_at]
    end
    it 'should match on arrive_at' do
      core[:arrive_at].should eq @params[:arrive_at]
    end
    it 'should match on usd_price' do
      core[:usd_price].should eq @params[:usd_price]
    end
  end
  describe '@attributes' do
    let(:attributes) { form_helper.instance_variable_get :@attributes }
    it 'should match params' do
      attributes.should eq @params
    end
    it 'should permit the right crap' do
      atts = attributes.permit :finish_zipcode,
        :finish_country,
        :finish_state,
        :finish_address1,
        :finish_address2
      atts.should_not be_blank
    end
    it 'should permit the right things' do
      attributes.permit(:start_address1, :start_address2).should eq start_address1: @start.address1, start_address2: @start.address2
    end
  end
  describe '#_destination_params' do
    let(:destination) { form_helper.send :_raw_destination_params }
    it 'should not be empty' do
      destination.should be_present
    end
    it 'should match on the key start_address1' do
      destination[:finish_address1].should eq @finish.address1
    end
    it 'should match on the key finish_address2' do
      destination[:finish_address2].should eq @finish.address2
    end
    it 'should match on the key finish_city' do
      destination[:finish_city].should eq @finish.city
    end
    it 'should match on the key finish_state' do
      destination[:finish_state].should eq @finish.state.id
    end
    it 'should match on the key finish_country' do
      destination[:finish_country].should eq @finish.country.id
    end
    it 'should match on the key finish_zipcode' do
      destination[:finish_zipcode].should eq @finish.zipcode
    end
  end
  describe '#truck_params' do
    it 'should create friendly params that match usd_price' do
      form_helper.truck_params[:usd_price].should eq @params[:usd_price]
    end
    it 'should create friendly params that match pickup_at' do
      form_helper.truck_params[:pickup_at].should eq @params[:pickup_at]
    end
    it 'should create friendly params that match arrive_at' do
      form_helper.truck_params[:arrive_at].should eq @params[:arrive_at]
    end
    it 'should have only 5 keys' do
      form_helper.truck_params.keys.count.should eq 5
    end
    it 'should have origin' do
      form_helper.truck_params[:origination].should eq @start
    end
    it 'should have destiny' do
      form_helper.truck_params[:destination].should eq @finish
    end
  end
  describe "#valid?" do
    it 'should be valid' do
      form_helper.should be_valid
    end
    it 'should have no errors' do
      form_helper.errors.full_messages.join(",").should == ""
    end
  end
  context 'invalid - causality' do
    before do
      @params[:pickup_at] = 15.days.from_now
      @params[:arrive_at] = 10.days.from_now
    end
    it 'should not be valid' do
      form_helper.should_not be_valid
    end
    it 'should complain about causality' do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /pic/
    end
  end
  context 'invalid - bad finish country' do
    before do
      @params[:finish_country] = "hell"
    end
    it 'should not be valid' do
      form_helper.should_not be_valid
    end
    it 'should complain about causality' do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /country/
    end
  end
  context 'invalid - bad finish state' do
    before do
      @params[:finish_state] = "hell"
    end
    it 'should not be valid' do
      form_helper.should_not be_valid
    end
    it 'should complain about causality' do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /state/
    end
  end
  context 'invalid - bad start country' do
    before do
      @params[:start_country] = "hell"
    end
    it 'should not be valid' do
      form_helper.should_not be_valid
    end
    it 'should complain about causality' do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /country/
    end
  end
  context 'invalid - bad start state' do
    before do
      @params[:start_state] = "hell"
    end
    it 'should not be valid' do
      form_helper.should_not be_valid
    end
    it 'should complain about causality' do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /state/
    end
  end
end