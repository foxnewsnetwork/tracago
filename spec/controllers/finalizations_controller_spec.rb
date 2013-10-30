require 'spec_helper'

describe Spree::FinalizationsController do

  describe "#show" do
    before do
      @finalization = ChineseFactory::Finalization.mock
    end
    it "should be successful" do
      spree_get :show, id: @finalization.id
      response.response_code.should eq 200
    end
  end
end