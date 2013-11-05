require 'spec_helper'

describe Spree::Finalizations::Serviceables::TrucksController do
  before do
    @finalization = ChineseFactory::Finalization.mock
    @start_address = ChineseFactory::Address.mock
    @finish_address = ChineseFactory::Address.mock
  end
  describe '#new' do
    let(:spree_new) { spree_get :new, finalization_id: @finalization.id }
    context 'anonymous' do
      it "should render the thing correctly" do
        spree_new
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it 'should engage the flash' do
        spree_new
        flash[:error].should =~ /in/
      end
    end
    context 'correct' do
      login_shop
      let(:current_shop) { controller.send :current_shop }
      before do
        @offer = ChineseFactory::Offer.belongs_to(current_shop).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        spree_new
      end
      it 'should render correctly' do
        response.response_code.should eq 200
      end
    end
  end

  describe '#create' do
    let(:spree_create) { -> { spree_post :create, finalization_id: @finalization.id, serviceable: @params } }
    let(:buyer) { controller.send :current_shop }
    let(:demand) { controller.instance_variable_get :@truck_demand }
    let(:valid) { controller.send :_valid? }
    let(:truck_serviceable) { controller.send :_truck_serviceable }
    context 'bad data' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(buyer).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        @start = ChineseFactory::Address.mock
        @finish = ChineseFactory::Address.mock
        @params = {
          start_address1: @start.address1,
          start_address2: @start.address2,
          start_city: @start.city,
          start_state: @start.state.id,
          start_country: 345345,
          start_zipcode: @start.zipcode,
          finish_address1: @finish.address1,
          finish_address2: @finish.address2,
          usd_price: 23842
        }
      end
      it 'should not create a demand' do
        spree_create.should_not change(Spree::ServiceDemand, :count)
      end
      it 'should engage a flash' do
        spree_create.call
        flash[:error].should be_present
      end
      it 'should render new' do
        spree_create.call
        response.should render_template "new"
      end
      it 'should be valid' do
        spree_create.call
        valid.should_not be_true
      end
    end
    context 'correct' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(buyer).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        @start = ChineseFactory::Address.mock
        @finish = ChineseFactory::Address.mock
        @params = {
          start_address1: @start.address1,
          start_address2: @start.address2,
          start_city: @start.city,
          start_state: @start.state,
          start_country: @start.country,
          start_zipcode: @start.zipcode,
          finish_address1: @finish.address1,
          finish_address2: @finish.address2,
          finish_city: @finish.city,
          finish_state: @finish.state,
          finish_country: @finish.country,
          finish_zipcode: @finish.zipcode,
          pickup_at: 10.days.from_now,
          arrive_at: 15.days.from_now,
          usd_price: 23842
        }
      end
      it 'should be a truck' do
        spree_create.call
        truck_serviceable.should be_a Spree::Serviceables::Truck
      end
      it 'should be a demand' do
        spree_create.call
        demand.should be_a Spree::ServiceDemand
      end
      it 'should be valid' do
        spree_create.call
        valid.should be_true
      end
      it 'should successfully create a ServiceDemand' do
        spree_create.should change(Spree::ServiceDemand, :count).by 1
      end
      it 'should not engage any flash' do
        spree_create.call
        flash[:error].should be_blank
      end
      it 'should redirect to that one place thing' do
        spree_create.call
        response.should redirect_to Spree.r.demand_path demand
      end
    end
    context 'anonymous user' do
      it 'should not create anything' do
        spree_create.should_not change(Spree::ServiceDemand, :count)
      end  
      it 'should redirect to the login path' do
        spree_create.call
        response.should redirect_to Spree.r.login_path(back: request.fullpath)
      end
      it 'should engage the flash' do
        spree_create.call
        flash[:error].should =~ /in/
      end
    end
    context 'wrong user' do
      login_shop
      it 'should not create anything' do
        spree_create.should_not change(Spree::ServiceDemand, :count)
      end  
      it 'should redirect to the login path' do
        spree_create.call
        response.should redirect_to Spree.r.root_path
      end
      it 'should engage the flash' do
        spree_create.call
        flash[:error].should =~ /in/
      end
    end

  end
end