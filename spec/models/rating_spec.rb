require 'spec_helper'

describe Spree::Rating do
  context 'factory' do
    let(:rating) { ChineseFactory::Rating.mock }
    it "should be a rating" do
      rating.should be_a Spree::Rating
    end
    it "should have a reviewer that is a shop" do
      rating.reviewer.should be_a Spree::Shop
    end
    it "should have a properly reviewed that is a shop" do
      rating.reviewed.should be_a Spree::Shop
    end
    it 'should have a context that is considered reviewable' do
      rating.reviewable.should be_a Spree::Finalization
    end
  end
  describe '#stars' do
    let(:bounds_property) { -> { ChineseFactory::Rating.mock.stars } }
    it 'should always be between 0 and 5' do
      12.times { (0..5).should include bounds_property.call }
    end
  end
end