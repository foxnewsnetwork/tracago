require 'spec_helper'

describe Array do
  describe "#filter_map" do
    before do
      @array = (0..10).to_a
    end
    let(:expected) do
      ['fizz',1,2,'fizz','buzz',5,'fizz',7,'buzz','fizz',10]
    end
    let(:actual) do
      @array.filter_map do |value|
        value.is_a?(Integer) && (value%3).zero?
      end.call { 'fizz' }.filter_map do |value|
        value.is_a?(Integer) && (value%4).zero?
      end.call { 'buzz' }
    end
    it "should properly filter and map the short array into a fizzbuzz array" do
      actual.should eq expected
    end
  end
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