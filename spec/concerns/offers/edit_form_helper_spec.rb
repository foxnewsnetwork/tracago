require 'spec_helper'

describe Spree::Offers::EditFormHelper do
  let(:helper) { Spree::Offers::EditFormHelper.new @params }
  context 'sanity' do
    it_should_behave_like "ActiveModel"
  end

  context "access" do
    before do
      @params = {
        minimum_pounds_per_load: rand(3454),
        transport_method: Spree::Offer::TransportMethods.random,
        usd_per_pound: (rand(544) / 1000.to_f),
        shipping_terms: Spree::Offer::Terms.random,
        expires_at: rand(42422).days.from_now,
        address1: Faker::AddressUS.street_address,
        address2: Faker::AddressUS.secondary_address,
        city: Faker::AddressUS.city,
        zipcode: Faker::AddressUS.zip_code,
        country: ChineseFactory::Country.mock.id,
        state: ChineseFactory::State.mock.id
      }
    end
    it "should properly access with the accessor minimum_pounds_per_load" do
      helper.minimum_pounds_per_load.should eq @params[:minimum_pounds_per_load]
    end

    it "should properly access with the accessor transport_method" do
      helper.transport_method.should eq @params[:transport_method]
    end

    it "should properly access with the accessor usd_per_pound" do
      helper.usd_per_pound.should eq @params[:usd_per_pound]
    end

    it "should properly access with the accessor shipping_terms" do
      helper.shipping_terms.should eq @params[:shipping_terms]
    end

    it "should properly access with the accessor expires_at" do
      helper.expires_at.should eq @params[:expires_at]
    end

    it "should properly access with the accessor address1" do
      helper.address1.should eq @params[:address1]
    end

    it "should properly access with the accessor address2" do
      helper.address2.should eq @params[:address2]
    end

    it "should properly access with the accessor city" do
      helper.city.should eq @params[:city]
    end

    it "should properly access with the accessor zipcode" do
      helper.zipcode.should eq @params[:zipcode]
    end

    it "should properly access with the accessor country" do
      helper.country.should eq @params[:country]
    end

    it "should properly access with the accessor state" do
      helper.state.should eq @params[:state]
    end

  end

  describe "#offer_params" do
    let(:params) { helper.offer_params }
    before do
      @params = {
        minimum_pounds_per_load: rand(3454),
        transport_method: Spree::Offer::TransportMethods.random,
        usd_per_pound: (rand(544) / 1000.to_f),
        shipping_terms: Spree::Offer::Terms.random,
        expires_at: rand(42422).days.from_now,
        address1: Faker::AddressUS.street_address,
        address2: Faker::AddressUS.secondary_address,
        city: Faker::AddressUS.city,
        zipcode: Faker::AddressUS.zip_code,
        country: ChineseFactory::Country.mock.id,
        state: ChineseFactory::State.mock.id
      }
    end
    it "should match params on the key minimum_pounds_per_load" do
      params[:minimum_pounds_per_load].should eq @params[:minimum_pounds_per_load]
    end

    it "should match params on the key transport_method" do
      params[:transport_method].should eq @params[:transport_method]
    end

    it "should match params on the key usd_per_pound" do
      params[:usd_per_pound].should eq @params[:usd_per_pound]
    end

    it "should match params on the key shipping_terms" do
      params[:shipping_terms].should eq @params[:shipping_terms]
    end

    it "should match params on the key expires_at" do
      params[:expires_at].should eq @params[:expires_at]
    end

    it "should have an address field" do
      params[:address].should be_a Spree::Address
    end

    it "should match on address's address1" do
      params[:address][:address1].should eq @params[:address1]
    end

    it "should match on address's address2" do
      params[:address][:address2].should eq @params[:address2]
    end

    it "should match on address's city" do
      params[:address][:city].should eq @params[:city]
    end

    it "should match on address's zipcode" do
      params[:address][:zipcode].should eq @params[:zipcode]
    end

    it "should match on address's country" do
      params[:address].country.id.should eq @params[:country]
    end

    it "should match on address's state" do
      params[:address].state.id.should eq @params[:state]
    end
  end

  describe "#errors" do
    let(:errors) { helper.errors }
    context 'success' do
      before do
        @params = {
          minimum_pounds_per_load: rand(3454),
          transport_method: Spree::Offer::TransportMethods.random,
          usd_per_pound: (rand(544) / 1000.to_f),
          shipping_terms: Spree::Offer::Terms.random,
          expires_at: rand(42422).days.from_now,
          address1: Faker::AddressUS.street_address,
          address2: Faker::AddressUS.secondary_address,
          city: Faker::AddressUS.city,
          zipcode: Faker::AddressUS.zip_code,
          country: ChineseFactory::Country.mock.id,
          state: ChineseFactory::State.mock.id
        }
      end
      it "should be valid" do
        helper.should be_valid
      end
      it "should have blank errors" do
        helper.valid?
        errors.full_messages.join(",").should == ""
      end
    end

    context 'failure - missing' do
      before do
        @params = {
          minimum_pounds_per_load: rand(3454),
          transport_method: Spree::Offer::TransportMethods.random,
          usd_per_pound: (rand(544) / 1000.to_f),
          shipping_terms: Spree::Offer::Terms.random,
          expires_at: rand(42422).days.from_now,
          address1: Faker::AddressUS.street_address,
          address2: Faker::AddressUS.secondary_address,
          city: Faker::AddressUS.city,
          zipcode: Faker::AddressUS.zip_code,
          country: ChineseFactory::Country.mock.id,
        }
      end
      it "should not be valid" do
        helper.should_not be_valid
      end
      it "should complain about state being missing" do
        helper.valid?
        errors.full_messages.join(",").should =~ /state/i
      end
    end

  end
end