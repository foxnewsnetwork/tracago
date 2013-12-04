require 'spec_helper'

describe Spree::Listings::Offers::FormHelper do
  let(:united_states) { ChineseFactory::Country.mock }
  let(:listing) { ChineseFactory::Listing.mock }
  let(:form_helper) { Spree::Listings::Offers::FormHelper.new(listing).tap { |f| f.attributes = @params } }
  before do
    @params = {
      shipping_terms: "FAS",
      country: united_states.romanized_name,
      state: Faker::AddressUS.state,
      city: Faker::AddressUS.city,
      address1: Faker::AddressUS.street_address,
      usd_per_pound: rand(22) + 1,
      loads: rand(23) + 1,
      minimum_pounds_per_load: rand(234234)
    }
  end
  describe '#_processed_country' do
    subject { form_helper.send :_processed_country }
    specify { should be_a Spree::Country }
  end

  describe '#_processed_state' do
    subject { form_helper.send :_processed_state }
    specify { should be_a Spree::State }
  end

  describe '#_processed_city' do
    subject { form_helper.send :_processed_city }
    specify { should be_a Spree::City }
  end

  describe '#_processed_address' do
    subject { form_helper.send :_processed_address }
    specify { should be_a Spree::Address }
  end

end