require 'spec_helper'

describe Spree::Offer do
  before do
    @offer = ChineseFactory::Offer.mock
  end

  describe "#update!" do
    before do
      @params = {
        minimum_pounds_per_load: rand(3454),
        transport_method: Spree::Offer::TransportMethods.random,
        usd_per_pound: (rand(544) / 1000.to_f),
        shipping_terms: Spree::Offer::Terms.random,
        expires_at: rand(42422).days.from_now,
        address1: Faker::AddressUS.street_address,
        address2: Faker::AddressUS.secondary_address,
        city: Faker::AddressUS.city,
        zipcode: Faker::AddressUS.zip_code,
        country: ChineseFactory::Country.mock.id,
        state: ChineseFactory::State.mock.id
      }
      @offer.update! Spree::Offers::EditFormHelper.new(@params).offer_params
    end
    it "should match on the relations country" do
      @offer.reload.address.country.id.should eq @params[:country]
    end
    it "should match on the relations state" do
      @offer.reload.address.state.id.should eq @params[:state]
    end
    it "should match on address address1" do
      @offer.reload.address.address1.should eq @params[:address1]
    end

    it "should match on address address2" do
      @offer.reload.address.address2.should eq @params[:address2]
    end

    it "should match on address city" do
      @offer.reload.address.city.should eq @params[:city]
    end

    it "should match on address zipcode" do
      @offer.reload.address.zipcode.should eq @params[:zipcode]
    end

    it "it should match the params minimum_pounds_per_load" do
      @offer.reload.minimum_pounds_per_load.to_s.should eq @params[:minimum_pounds_per_load].to_s
    end
    it "it should match the params transport_method" do
      @offer.reload.transport_method.to_s.should eq @params[:transport_method].to_s
    end
    it "it should match the params usd_per_pound" do
      @offer.reload.usd_per_pound.to_s.should eq @params[:usd_per_pound].to_s
    end
    it "it should match the params shipping_terms" do
      @offer.reload.shipping_terms.to_s.should eq @params[:shipping_terms].to_s
    end
    it "it should match the params expires_at" do
      @offer.reload.expires_at.to_s.should eq @params[:expires_at].to_s
    end

  end
  describe "#presentable_expires_at" do
    it "should give a date" do
      @offer.presentable_expires_at.should be_present
    end
    it "should be never if the attribute is nil" do
      @offer.tap { |o| o.expires_at = nil }.presentable_expires_at.should eq Spree.t(:never)
    end
  end
  describe "#total_usd" do
    it "should provide a value for total cost" do
      @offer.total_usd.should be_present
    end
  end
  describe "#to_summary" do
    let(:summary) { @offer.to_summary }
    it "should suggest quantity and shipping terms" do
      summary.should =~ /lbs/
    end
  end
  describe "::completed" do
    before do
      9.times { ChineseFactory::Offer.mock }
    end
    let(:completed) { Spree::Offer.completed }
    it "should present to me all the offers with addresses, users, and listings" do
      completed.count.should eq 10
      completed.each do |offer|
        offer.listing.should be_a Spree::Listing
        offer.shop.should be_a Spree::Shop
        offer.address.should be_a Spree::Address
      end
    end
  end
end