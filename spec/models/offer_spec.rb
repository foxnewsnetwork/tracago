require 'spec_helper'

describe Spree::Offer do
  before do
    @offer = ChineseFactory::Offer.mock
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