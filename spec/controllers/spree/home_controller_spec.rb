require 'spec_helper'

describe Spree::HomeController do
  describe "#index" do
    before do
      spree_get :index
    end
    it "should respond properly with the ok http code" do
      response.response_code.should eq 200
    end
  end
end