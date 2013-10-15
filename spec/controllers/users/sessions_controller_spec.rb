require 'spec_helper'

describe Spree::Users::SessionsController do
  describe "#new" do
    let(:spree_new) { -> { spree_get :new, back: @back } }
    context "simple usage" do
      before { spree_new.call }
      it "should successfully render the page" do
        response.response_code.should eq 200
      end
      it "should render the correct template" do
        response.should render_template "new"
      end
    end
  end
end