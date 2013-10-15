require 'spec_helper'

describe Spree::Stockpiles::Addresses::FormHelper do
  it_should_behave_like "ActiveModel"
  describe "::model_name" do
    let(:name) { Spree::Stockpiles::Addresses::FormHelper.model_name }
    it "should a reasonable model name" do
      name.singular.to_str.should eq "address_form_helper"
      name.plural.to_str.should eq "address_form_helpers"
    end
  end
end