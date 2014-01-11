require 'spec_helper'

class Itps::LinkListTools::TestRecord
  attr_accessor :id, :reference_id
  def initialize(n=nil)
    @@counter ||= 0
    @id = @@counter
    @@counter += 1
    @reference_id = n if n.present?
  end
  def inspect
    "<R: id=#{@id} | reference_id=#{@reference_id} >"
  end
  alias_method :to_s, :inspect
end
describe Itps::LinkListTools::Sorter do
  let(:rec) { Itps::LinkListTools::TestRecord }
  describe "#sort_in_order" do
    before do
      @records = [rec.new]
      @records << rec.new(4)
      @records << rec.new(1)
      @records << rec.new(2)
      @records << rec.new(0)
      @records << rec.new(3)
    end
    let(:sorted_records) { Itps::LinkListTools.sort_in_order(@records) }
    it 'should sort in such a way that the array is in order of the linked list' do
      sorted_records.map(&:id).should eq [0,4,1,2,3,5]
    end
  end
end