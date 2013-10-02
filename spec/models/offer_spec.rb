require 'spec_helper'

describe Spree::Offer do
  describe "::completed" do
    before do
      10.times { ChineseFactory::Offer.mock }
    end
    let(:completed) { Spree::Offer.completed }
    it "should present to me all the offers with addresses, users, and listings" do
      completed.count.should eq 10
      completed.each do |offer|
        offer.listing.should be_a Spree::Listing
        offer.user.should be_a Spree::User
        offer.address.should be_a Spree::Address
      end
    end
  end
end