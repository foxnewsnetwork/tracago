require 'spec_helper'

describe Spree::Listings::StockpilesController do
  let(:create) { -> { spree_post :create, listing_id: @listing.id, stockpile: @stockpile } }

  describe "#new" do
    let(:listing) { ChineseFactory::Listing.mock }
    it "should be successful" do
      spree_get :new, listing_id: listing.id
      response.response_code.should eq 200
    end
  end

  describe "#create - fail" do
    before do
      @listing = Spree::Listing.create!
    end  
    it "should be a valid listing" do
      @listing.should be_a Spree::Listing
      @listing.should be_require_shop
      @listing.should be_require_stockpile
      @listing.should_not be_complete
    end

    context "missing origin" do
      before do
        @stockpile = {
          material: ChineseFactory::Material.mock.id,
          packaging: ChineseFactory::OptionValue.mock.id,
          weight: rand(2408245),
          notes: Faker::Lorem.paragraph
        }
      end
      it "should not create a new stockpile" do
        create.should_not change(@listing, :stockpile)
        create.should_not change(Spree::Stockpile, :count)
      end

      it "should present the correct flash message" do
        create.call
        flash[:error].should =~ /origin/i
      end
    end

    context "missing weight" do
      before do
        @stockpile = {
          material: ChineseFactory::Material.mock.id,
          packaging: ChineseFactory::OptionValue.mock.id,
          process_state: ChineseFactory::OptionValue.mock.id,
          origin: ChineseFactory::OptionValue.mock.presentation,
          notes: Faker::Lorem.paragraph
        }
      end
      it "should not create a new stockpile" do
        create.should_not change(@listing, :stockpile)
        create.should_not change(Spree::Stockpile, :count)
      end

      it "should present the correct flash message" do
        create.call
        flash[:error].should =~ /weight/i
      end
    end 

    context "missing material" do
      before do
        @stockpile = {
          weight: rand(2408245),
          notes: Faker::Lorem.paragraph
        }
      end
      it "should not create a new stockpile" do
        create.should_not change(@listing, :stockpile)
        create.should_not change(Spree::Stockpile, :count)
      end
      it "should present the correct flash message" do
        create.call
        flash[:error].should =~ /material/
      end
    end
  end

  describe "#create - origin" do
    before do
      @material = ChineseFactory::Material.mock
      @packaging = ChineseFactory::OptionValue.mock
      @origin = Faker::Name.name
      @listing = ChineseFactory::Listing.mock.tap do |listing|
        listing.update_attributes stockpile_id: nil
      end
      @stockpile = {
        material: @material.id,
        weight: rand(2344),
        packaging: @packaging.presentation,
        origin: @origin,
        notes: Faker::Lorem.paragraph
      }
    end
    it "should create an option_value" do
      create.should change(Spree::OptionValue, :count).by(1)
    end
    it "should still create the stockpile" do
      create.should change(Spree::Stockpile, :count).by(1)
    end
  end

  describe "#create" do
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

    it "should not create a new origin option value when one exists" do
      create.should_not change(Spree::OptionValue, :count)
    end

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