require 'spec_helper'

describe Spree::ListingsController do

  describe "#new" do
    it "should redirect to the related stockpile page" do
      spree_get :new
      response.response_code.should eq 200
    end
  end

  describe "#show" do
    let(:listing) { ChineseFactory::Listing.mock }
    it "should merely redirect to the respective stockpile path" do
      spree_get :show, id: listing.id
      response.should redirect_to Spree.r.stockpile_path listing.stockpile
    end
    it "should properly render a 404" do
      spree_get :show, id: 2305902347593475
      response.response_code.should eq 404
    end
  end

  describe "#create" do
    let(:create) { -> { spree_post :create, listing: @params } }
    before do
      @state = ChineseFactory::State.mock
      @country = @state.country
      @params = {
        material: ChineseFactory::Material.mock.id,
        pounds_on_hand: rand(234584),
        packaging: ChineseFactory::OptionValue.mock.presentation,
        process_state: ChineseFactory::OptionValue.mock.presentation,
        origin_products: [ChineseFactory::OriginProduct.mock.presentation].join(","),
        notes: Faker::Lorem.paragraph,
        available_on: rand(1).days.from_now,
        expires_on: rand(245).days.from_now,
        address1: Faker::Address.street_address,
        address2: Faker::Address.secondary_address,
        city: Faker::AddressUS.city,
        zipcode: 90210,
        state: @state.id,
        country: @country.id
      }
    end
    context "failure - missing material" do
      before do
        @params[:material] = nil
      end
      let(:params) { controller.send :_raw_stockpile_params }
      it "should successfully create a listing" do
        create.should_not change(Spree::Listing, :count)
      end
      it "should create a stockpile" do
        create.should_not change(Spree::Stockpile, :count)
      end
      it "should redirect back to the same page in question" do
        create.call
        response.should render_template(:new)
      end
      it "should generate a proper flash message about bad materials" do
        create.call
        flash[:error].should =~ /materia/i
      end
    end
    context "failure - missing pounds_on_hand" do
      before do
        @params[:pounds_on_hand] = nil
      end
      let(:params) { controller.send :_raw_stockpile_params }
      it "should successfully create a listing" do
        create.should_not change(Spree::Listing, :count)
      end
      it "should create a stockpile" do
        create.should_not change(Spree::Stockpile, :count)
      end
      it "should redirect back to the same page in question" do
        create.call
        response.should render_template :new
      end
      it "should generate a proper flash message about bad materials" do
        create.call
        flash[:error].should =~ /pounds on hand/i
      end
    end
    context "success - logged out" do
      it "should successfully create a listing" do
        create.should change(Spree::Listing, :count).by(1)
      end
      it "should create a stockpile" do
        create.should change(Spree::Stockpile, :count).by(1)
      end
      context "data integrity" do
        before { create.call }
        let(:listing) { controller.send :_listing }
        let(:stockpile) { controller.send :_stockpile }
        let(:option_names) { stockpile.option_values.map(&:presentation) }
        it "should relate the listing and the stockpile" do
          listing.stockpile.should eq stockpile
        end
        it "should have a stockpile with the proper material" do
          stockpile.material.id.should eq @params[:material]
        end
        it "should have the proper pounds_on_hand" do
          stockpile.pounds_on_hand.should eq @params[:pounds_on_hand]
        end
        it "should have the proper option values" do
          stockpile.option_values.count.should eq 2
          option_names.should include @params[:packaging]
          option_names.should include @params[:process_state]
        end
        it "should have the proper notes" do
          stockpile.notes.should eq @params[:notes]
        end
        it "should have the proper availability date" do
          listing.available_on.to_formatted_s(:short).should eq @params[:available_on].to_formatted_s(:short)
        end
        it "should have the proper expiration date" do
          listing.expires_on.to_formatted_s(:short).should eq @params[:expires_on].to_formatted_s(:short)
        end
        it "should still require a shop, but not require a stockpile" do
          listing.should_not be_complete
          listing.should be_require_shop
        end 
      end
    end

    context "success - logged in" do
      login_shop
      it "should successfully create a listing" do
        create.should change(Spree::Listing, :count).by(1)
      end
      it "should create a stockpile" do
        create.should change(Spree::Stockpile, :count).by(1)
      end
      context "data integrity" do
        before { create.call }
        let(:valid?) { controller.send :_valid? }
        let(:listing) { controller.send :_listing }
        let(:stockpile) { controller.send :_stockpile }
        let(:option_names) { stockpile.option_values.map(&:presentation) }
        let(:errors) { controller.send( :_form_helper ).errors.full_messages.join(",") }
        it "should have an empty errors error" do
          valid?
          errors.should =~ /^$/
        end
        it "should be valid" do
          valid?.should be_true
        end
        it "should relate the listing and the stockpile" do
          listing.stockpile.should eq stockpile
        end
        it "should still no longer require a shop and only require an address" do
          listing.should be_complete
        end 
        it "should have a stockpile with the proper material" do
          stockpile.material.id.should eq @params[:material]
        end
        it "should have the proper pounds_on_hand" do
          stockpile.pounds_on_hand.should eq @params[:pounds_on_hand]
        end
        it "should have the proper option values" do
          stockpile.option_values.count.should eq 2
          option_names.should include @params[:packaging]
          option_names.should include @params[:process_state]
        end
        it "should have the proper notes" do
          stockpile.notes.should eq @params[:notes]
        end
        it "should have the proper availability date" do
          listing.available_on.to_formatted_s(:short).should eq @params[:available_on].to_formatted_s(:short)
        end
        it "should have the proper expiration date" do
          listing.expires_on.to_formatted_s(:short).should eq @params[:expires_on].to_formatted_s(:short)
        end
      end
    end

  end

end