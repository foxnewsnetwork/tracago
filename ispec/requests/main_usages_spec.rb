require 'integration_helper'

ChineseIntegration::Ordered.instance.run! :main_usage

describe main_usage do

  describe '#start_at_root' do
    let(:state) { main_usage.state_at :start_at_root }

    it 'should be valid' do
      state.should be_valid
    end

    it 'should have no secrets' do
      state.errors.full_messages.join(",").should == ""
    end
  end

  describe '#seller_visits_new_listing_page' do
    let(:state) { main_usage.state_at :seller_visits_new_listing_page }
  end

  describe '#seller_makes_a_listing' do
    let(:state) { main_usage.state_at :seller_makes_a_listing }
  end

  describe '#buyer_visits_listing_page' do
    let(:state) { main_usage.state_at :buyer_visits_listing_page }
  end

  describe '#buyer_makes_an_offer' do
    let(:state) { main_usage.state_at :buyer_makes_an_offer }
  end

  describe '#seller_makes_a_suggestion' do
    let(:state) { main_usage.state_at :seller_makes_a_suggestion }
  end

  describe '#buyer_modifies_offer_accordingly' do
    let(:state) { main_usage.state_at :buyer_modifies_offer_accordingly }
  end

  describe '#seller_accepts_new_offer' do
    let(:state) { main_usage.state_at :seller_accepts_new_offer }
  end

end
