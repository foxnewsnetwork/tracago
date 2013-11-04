require 'spec_helper'

describe Spree::Seaport do
  let(:seaport) { ChineseFactory::Seaport.mock }
  let(:ship_model) { ChineseFactory::Serviceables::Ship }
  describe "#arrivals" do
    before do
      ship_maker = -> { ship_model.new.tap { |s| s.finish_port = seaport }.mock }
      @arrivals = (0..9).map { ship_maker.call }
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
