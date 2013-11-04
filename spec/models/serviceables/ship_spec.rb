require 'spec_helper'

describe Spree::Serviceables::Ship do
  before do
    @ship = ChineseFactory::Serviceables::Ship.mock
  end
  context 'factory' do
    subject { @ship }
    specify { should be_a Spree::Serviceables::Ship }
  end
  context 'origination' do
    subject { @ship.start_port }
    specify { should be_a Spree::Seaport }
  end
  context 'destination' do
    subject { @ship.finish_port }
    specify { should be_a Spree::Seaport }
  end
end