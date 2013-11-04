require 'spec_helper'

describe Spree::Finalizations::Serviceables::ShipsController do
  before do
    @finalization = ChineseFactory::Finalization.mock
    @start_port = ChineseFactory::Seaport.mock
    @finish_port = ChineseFactory::Seaport.mock
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
    let(:demand) { controller.instance_variable_get :@ship_demand }
    context 'bad data' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(buyer).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        @params = {
          start_port: @start_port.port_code,
          start_terminal_code: '1a',
          finish_port: @finish_port.port_code,
          finish_terminal_code: '3c',
          carrier_name: "Maersk",
          depart_at: 10.days.from_now,
          arrive_at: 5.days.from_now,
          cutoff_at: 8.days.from_now,
          usd_price: 300
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
    end
    context 'correct' do
      login_shop
      before do
        @offer = ChineseFactory::Offer.belongs_to(buyer).mock
        @finalization = ChineseFactory::Finalization.belongs_to(@offer).mock
        @params = {
          start_port: @start_port.port_code,
          start_terminal_code: '1a',
          finish_port: @finish_port.port_code,
          finish_terminal_code: '3c',
          carrier_name: "Maersk",
          depart_at: 10.days.from_now,
          arrive_at: 40.days.from_now,
          cutoff_at: 8.days.from_now,
          usd_price: 300
        }
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