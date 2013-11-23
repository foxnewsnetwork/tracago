require 'spec_helper'

describe Spree::Listings::QueryHandler do
  it_should_behave_like "ActiveModel"

  let(:handler) { Spree::Listings::QueryHandler.new @params }
  
  before do
    @city = ChineseFactory::City.mock
    @params = {}
  end

  context 'junk' do
    it 'should default page' do
      handler.page.should be_present
    end
    it 'should default per_page' do
      handler.per_page.should be_present
    end
  end
  describe '#show_state? - false' do
    before do
      @params = {}
    end
    it 'should not require state if a country is missing' do
      handler.should_not be_show_state
    end
  end

  describe '#show_state? - true' do
    before do
      @params = {
        country: @city.country.permalink
      }
    end
    it 'should require the state if the country is present' do
      handler.should be_show_state
    end
  end

  describe '#show_city? - false' do
    before do
      @params = {
        country: @city.country.permalink
      }
    end
    it 'should not show city if there is no state' do
      handler.should_not be_show_city
    end
  end

  describe '#show_city? - true' do
    before do
      @params = {
        country: @city.country.permalink,
        state: @city.state.permalink
      }
    end
    it 'should show city when there is a state' do
      handler.should be_show_city
    end
  end

end