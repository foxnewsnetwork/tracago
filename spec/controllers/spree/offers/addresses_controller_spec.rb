require 'spec_helper'

describe Spree::Offers::AddressesController do
  before do
    @offer = ChineseFactory::Offer.mock
  end

  describe "#new" do
    before do
      @address = {
        city: Faker::Address.city,
        state: Faker::AddressUS.state,
        country: Faker::Address.country,
        offer_id: @offer.id
      }
      spree_get :new, @address
    end
    it "should be okay" do
      response.response_code.should eq 200
    end
  end

  describe "#create" do
    let(:create) do
      -> { spree_post :create, address: @address, offer_id: @offer.id }
    end
    let(:offer) do
      controller.instance_variable_get(:@offer)
    end
    let(:address_params) do
      controller.send(:_address_params)
    end
    let(:post_address_params) do
      controller.send(:_post_address_params)
    end
    before do
      @address = ChineseFactory::Address.new.attributes.permit(:address1, :address2, :city, :state, :country, :zipcode)
      @address[:country] = @address[:country].id
      @address[:state] = @address[:state].id
    end

    context "private methods" do
      before do 
        @msgen = -> (key) { "@address[#{key}] = #{@address[key]}\naddress_params[#{key}] = #{address_params[key]}" }
        create.call
      end
      it "should exactly match the given attributes with rail's strong parameters" do
        @address.each do |key, value|
          post_address_params[key].to_s.should eq(value.to_s)
        end
      end
      it "should be such that the given parameters match exactly the crap I feed into it" do
        [:address1, :address2, :city, :zipcode, :country, :state].each do |key|
          address_params[key].to_s.should eq(@address[key].to_s)
        end
      end
    end
    it "starting out, the address should be different" do
      @address.each do |key, value|
        @offer.destination[key].should_not eq value
      end
    end
    it "should create a new address" do
      create.should change(Spree::Address, :count).by 1
    end
    it "should explicity have replaced the address_id with a new one" do
      address_id = @offer.address_id
      create.call
      offer.address_id.should_not eq address_id
    end
    it "should have initialized an offer instance variable" do
      create.call
      offer.should_not be_blank
    end
    it "should connect the address with the offer" do
      create.call
      offer.destination.should be_present
      offer.destination.address1.should eq @address[:address1]
      offer.destination.city.should eq @address[:city]
      offer.destination.address2.should eq @address[:address2]
    end
  end

end