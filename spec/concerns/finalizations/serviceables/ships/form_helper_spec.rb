require 'spec_helper'

describe Spree::Finalizations::Serviceables::Ships::FormHelper do
  it_should_behave_like "ActiveModel"
  let(:form_helper) { Spree::Finalizations::Serviceables::Ships::FormHelper.new @params }
  describe "#valid?" do
    before do
      @params = {
        origination_port_code: "USLAX",
        destination_port_code: "CNSHA",
        carrier_name: "Maersk",
        depart_at: 10.days.from_now,
        arrive_at: 40.days.from_now,
        cutoff_at: 8.days.from_now,
        usd_price: 300
      }
    end
    it "should be valid" do
      form_helper.should be_valid
    end
    it "should therefore have blank errors" do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should == ""
    end
  end
  context "invalid" do
    before do
      @params = {
        origination_port_code: "USLAX",
        destination_port_code: "CNSHA",
        carrier_name: "Maersk",
        depart_at: 10.days.from_now,
        arrive_at: 5.days.from_now,
        cutoff_at: 8.days.from_now,
        usd_price: 300
      }
    end
    it "should be valid" do
      form_helper.should_not be_valid
    end
    it "should therefore have blank errors" do
      form_helper.valid?
      form_helper.errors.full_messages.join(",").should =~ /last/
    end
  end
end