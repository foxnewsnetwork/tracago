require 'spec_helper'

describe Spree::ListingsController do

  describe "#new" do
    it "should render the page as requested" do
      spree_get :new
      response.response_code.should eq 200
    end
  end

  describe "#create" do
    let(:create) { -> { spree_post :create, listing: @create_params } }
    let(:listing) { controller.instance_variable_get :@listing }
    before do
      @create_params = {
        category: "PET",
        weight: rand(582454),
        available_on: rand(24).days.from_now,
        expires_on: rand(32).days.ago
      }
    end

    it "should not have a nil warden client" do
      request.env['warden'].should be_present
    end
    it "should allow an anonymous user to successfully create a listing" do
      create.should change(Spree::Listing, :count).by(1)
    end
    it "should summarily redirect to the stockpile step" do
      create.call
      response.should redirect_to Spree.r.new_listing_stockpile_path(listing, weight: @create_params[:weight])
    end
    it "should create a listing that is missing a shop, and a stockpile, and is therefore not complete" do
      create.call
      listing.should be_require_shop
      listing.should be_require_stockpile
      listing.should_not be_complete
      listing.should be_a Spree::Listing
    end

  end
end