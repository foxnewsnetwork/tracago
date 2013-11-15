require 'spec_helper'

describe Spree::Seaport do
  let(:seaport) { ChineseFactory::Seaport.mock }
  let(:ship_model) { ChineseFactory::Serviceables::Ship }
  describe '#mock' do
    it 'should correctly mock' do
      ship = ship_model.mock
      seaport.should be_a Spree::Seaport
      ship.finish_port = seaport
      ship.save!
      ship.finish_port.should eq seaport
      ship.should be_a Spree::Serviceables::Ship
    end
  end
  describe "#arrivals" do
    before do
      @arrivals = (0..9).map do
        ship = ship_model.mock
        ship.finish_port = seaport
        ship.save!
        ship
      end
    end
    it "should match one-for-one the arrivals" do
      seaport.arrivals.should eq @arrivals
    end
  end
  describe "#departures" do
    before do
      ship_maker = -> { ship_model.new.tap { |s| s.start_port = seaport }.mock }
      @departures = (0..9).map { ship_maker.call }
    end
    it "should match one-for-one the departures" do
      seaport.departures.should eq @departures
    end
  end
end
