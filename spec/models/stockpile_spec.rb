require 'spec_helper'

describe Spree::Stockpile do
  describe "::completed" do
    before do
      @stockpiles = (0..9).map { ChineseFactory::Listing.mock }.map(&:stockpile)
      @shitty_stockpiles = [ChineseFactory::Stockpile.mock]
      Spree::Stockpile.create material_id: 2, pounds_on_hand: 232454
    end
    let(:stockpiles) { Spree::Stockpile.completed }
    it "should provide me with stockpiles that are considered completed" do
      stockpiles.each do |stockpile|
        stockpile.listing.should be_present
        stockpile.should_not be_require_shop
        stockpile.should_not be_require_address
      end
    end
  end
  describe "#properties" do
    before do
      @evil_option_type = ChineseFactory::OptionType.mock
      @okay_option_type = ChineseFactory::OptionType.mock
      @stockpile = ChineseFactory::Stockpile.mock
      factory = ChineseFactory::OptionValue.belongs_to(@stockpile)
      10.times { factory.belongs_to(@evil_option_type).create }
      10.times { factory.belongs_to(@okay_option_type).create }
    end
    let(:stockpile) { @stockpile.reload }
    let(:actual) do 
      stockpile.properties.map { |a| a.sort { |a,b| a.id <=> b.id } }
    end
    let(:expected) do
      [@evil_option_type.option_values, @okay_option_type.option_values].map { |a| a.sort { |a,b| a.id <=> b.id } }
    end

    it "should have some option values" do
      @evil_option_type.option_values.count.should > 0
      @evil_option_type.option_values.each do |ov|
        ov.should be_a Spree::OptionValue
      end
    end

    it "should have stacked some option_values onto the stockpile" do
      @stockpile.option_values.count.should > 0
      @stockpile.option_values.each do |ov|
        ov.should be_a Spree::OptionValue
      end
    end

    it "should be an array of option values" do
      stockpile.properties.each do |ps|
        ps.should be_a Array
      end
    end

    it "should organize the properties by option_types and present them as 2d arrays" do
      actual.should eq expected
    end
  end
end 