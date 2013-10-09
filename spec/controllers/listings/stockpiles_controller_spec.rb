require 'spec_helper'

describe Spree::Listings::StockpilesController do
  describe "#new" do
    let(:listing) { ChineseFactory::Listing.mock }
    it "should be successful" do
      spree_get :new, listing_id: listing.id
      response.response_code.should eq 200
    end
  end

  describe "#create - fail" do

  end

  describe "#create" do
    let(:create) { -> { spree_post :create, listing_id: @listing.id, stockpile: @stockpile } }
    before do
      @material = ChineseFactory::Material.mock
      @packaging = ChineseFactory::OptionValue.mock
      @process_state = ChineseFactory::OptionValue.mock
      @origin = ChineseFactory::OptionValue.mock
      @listing = ChineseFactory::Listing.mock.tap do |listing|
        listing.update_attributes stockpile_id: nil
      end
      @stockpile = {
        material: @material.id,
        weight: rand(2344),
        packaging: @packaging.presentation,
        process_state: @process_state.presentation,
        origin: @origin.presentation,
        notes: Faker::Lorem.paragraph
      }
    end
    let(:stockpile) { controller.send :_stockpile }
    let(:stockpile_params) { controller.send :_stockpile_params }
    let(:listing) { controller.send :_listing }

    it "should properly generate the correct stockpile parmas" do
      create.call
      stockpile_params[:material].should be_a Spree::Material
      stockpile_params[:option_values].should include @packaging
      stockpile_params[:option_values].should include @process_state
      stockpile_params[:option_values].should include @origin
      stockpile_params.keys.should_not include :weight
      stockpile_params[:pounds_on_hand].to_i.should eq @stockpile[:weight]
    end
    it "should create a stockpile for this particular listing" do
      create.call
      stockpile.should be_a Spree::Stockpile
      listing.stockpile.should be_a Spree::Stockpile
    end
  end
end