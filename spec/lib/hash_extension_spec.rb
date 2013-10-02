require 'spec_helper'

describe Hash do
  
  describe "#initializing_merge" do
    before do
      @hash1 = {
        dog: 1,
        cat: 2,
        bat: 3
      }
      @hash2 = {
        dog: "dog",
        cat: nil,
        bat: "",
        nig: {}
      }
    end
    let(:expected) do
      {
        dog: "dog",
        cat: 2,
        bat: 3
      }
    end
    let(:actual) do
      @hash1.initializing_merge @hash2
    end
    it "should only merge if the hash2 has non blank keys" do
      actual.should eq expected
    end
    it "should completely ignore blank arrays" do
      @hash1.initializing_merge(Hash.new).should eq @hash1
    end
  end
end