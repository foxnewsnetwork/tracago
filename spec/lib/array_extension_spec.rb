require 'spec_helper'

describe Array do
  describe "#rand" do
    before do
      @array = [1,2,3,4,5,6,7]
    end
    it "should give me an element that is within the array" do
      10.times { @array.should include @array.random }
    end
  end
  describe "#uniq_merge" do
    before do
      @array = []
      @array.push( name: :dog, stuff: ["dog"] )
      @array.push( name: :cat, stuff: ["cat"] )
      @array.push( name: :dog, stuff: ["dog2"] )
      @array.push( name: :dog, stuff: ["dog3"] )
      @expected = [
        {
          :name => :dog,
          :stuff => ["dog", "dog2", "dog3"]
        },
        {
          :name => :cat,
          :stuff => ["cat"]
        }
      ]
    end
    let(:actual) do
      @array.uniq_merge do |hash|
        hash[:name]
      end.call do |a,b|
        a.should be_a Hash
        b.should be_a Hash
        a[:stuff] += b[:stuff]
        a
      end
    end
    it "should properly merge together a quirky array" do
      actual.should eq @expected
    end

  end
end