require 'spec_helper'

describe Spree::Finalization do
  before do
    @finalization = ChineseFactory::Finalization.mock
  end
  context 'factory' do
    subject { @finalization }
    it "should be a valid finalization" do
      should be_valid
    end
    it "should be the proper class" do
      should be_a Spree::Finalization
    end
    it "should be fresh" do
      should be_fresh
    end
  end

  describe "::fresh" do
    subject { Spree::Finalization.fresh }
    it "should include the finalization we have created" do
      should include @finalization
    end
  end

  describe "#offer" do
    let(:offer) { @finalization.offer }
    it "should have non empty finalizations" do
      offer.finalizations.should be_present
      offer.finalizations.should include @finalization
    end
    it "should point back at the correct finalization" do
      offer.fresh_finalization.should eq @finalization
    end
    it "should have an offer that is locked down because it has been accepted already" do
      offer.should be_accepted
    end
    it "should be an offer" do
      offer.should be_a Spree::Offer
    end
  end

  describe "#fresh?" do
    before do
      @stale = ChineseFactory::Finalization.mock.tap do |t|
        t.expires_at = 1.day.ago
      end
    end
    it "expired things should be stale" do
      @stale.should_not be_fresh
    end
    it "nonexpired things should be fresh" do
      @finalization.should be_fresh
    end
  end
end