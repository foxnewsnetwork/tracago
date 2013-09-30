require 'spec_helper'

describe Spree::Shop do
  describe "#stockpiles" do
    before do
      @shop = ChineseFactory::Shop.mock
      @listings = (0..9).map { ChineseFactory::Listing.belongs_to(@shop).create }
    end
    let(:actual) { @shop.stockpiles.to_a }
    let(:expected) { @listings.map(&:stockpile) }
    it "should properly associate a shop with its stockpiles" do
      actual.should eq expected
    end
  end
end