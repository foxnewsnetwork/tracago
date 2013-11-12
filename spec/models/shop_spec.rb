require 'spec_helper'

describe Spree::Shop do
  before do
    @shop = ChineseFactory::Shop.mock
  end
  describe "#stockpiles" do
    before do
      @listings = (0..9).map { ChineseFactory::Listing.belongs_to(@shop).create }
    end
    let(:actual) { @shop.stockpiles.to_a }
    let(:expected) { @listings.map(&:stockpile) }
    it "should properly associate a shop with its stockpiles" do
      actual.should eq expected
    end
  end
  context 'rating' do
    let(:received_average_stars) { @shop.received_average_stars }
    describe '#received_average_stars' do
      it 'should be delightfully nil when a shop has no received ratings' do
        received_average_stars.should be_blank
      end
    end
    describe '#received_average_stars - one-two' do
      before do
        @rating = ChineseFactory::Rating.belongs_to(@shop).mock
      end
      it 'should have average stars be equal to rating stars be the same' do
        @rating.stars.should eq received_average_stars
      end
    end
    describe '#received_average_stars - in bounds' do
      before do
        @ratings = (0..9).map { ChineseFactory::Rating.belongs_to(@shop).mock }
      end
      it 'should be in the same range of 0 to 5' do
        (0..5).should include received_average_stars
      end
    end
    describe '#rating_stars' do
      it 'should be the same stars' do
        @shop.rating_stars.should eq received_average_stars
      end
    end
  end
end