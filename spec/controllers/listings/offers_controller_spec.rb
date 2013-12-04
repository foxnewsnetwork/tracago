require 'spec_helper'

describe Spree::Listings::OffersController do
  before do
    @listing = ChineseFactory::Listing.mock
    @united_states = ChineseFactory::Country.mock
  end
  context '#new' do
    it 'should have tests'
  end

  context '#index' do
    it 'should have tests'
  end

  context '#create' do
    let(:create) { post :create, listing_id: @listing.id, offers: @params }
    let(:offer) { controller.send :_offer }
    before do
      @params = {
        shipping_terms: "FAS",
        country: @united_states.romanized_name,
        state: Faker::AddressUS.state,
        city: Faker::AddressUS.city,
        address1: Faker::AddressUS.street_address,
        usd_per_pound: rand(22) + 1,
        loads: rand(23) + 1,
        minimum_pounds_per_load: rand(234234)
      }
    end

    it 'should not create a country' do
      lambda { create }.should_not change(Spree::Country, :count)
    end

    it 'should create the state' do
      lambda { create }.should change(Spree::State, :count).by 1
    end

    it 'should create the city' do
      lambda { create }.should change(Spree::City, :count).by 1
    end

    it 'should create the address' do
      lambda { create }.should change(Spree::Address, :count).by 1
    end

    it 'should create the offer' do
      lambda { create }.should change(Spree::Offer, :count).by 1
    end

    it 'should redirect to the user path' do
      create
      response.should redirect_to Spree.r.new_offer_user_path(offer)
    end

    it 'should have nothing in the flash message' do
      create
      flash[:error].to_s.should eq ""
    end
  end

  context '#confirm' do
    it 'should have tests'
  end

end

