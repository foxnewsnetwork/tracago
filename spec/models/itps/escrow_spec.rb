# == Schema Information
#
# Table name: itps_escrows
#
#  id                       :integer          not null, primary key
#  service_party_id         :integer          not null
#  payment_party_id         :integer          not null
#  draft_party_id           :integer          not null
#  permalink                :string(255)      not null
#  status_key               :string(255)
#  completed_at             :datetime
#  deleted_at               :datetime
#  payment_party_agreed_at  :datetime
#  serviced_party_agreed_at :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  payment_party_agree_key  :string(255)
#  service_party_agree_key  :string(255)
#

require 'spec_helper'

describe Itps::Escrow do

  describe "#ordered_steps" do
    before do
      @escrow = JewFactory::Escrow.mock
      @steps = (0..4).map { |k| @escrow.steps.create title: "step#{k}", instructions: 'nothing' }
    end
    let(:unordered_steps) { @escrow.steps }
    let(:steps) { @escrow.ordered_steps }
    let(:ordered_steps) { Itps::LinkListTools.sort_in_order unordered_steps }
    it 'should be properly tied together' do
      @escrow.steps.should eq @steps
    end
    it 'should return a ordered array in the order of the linked list' do
      ordered_steps.should_not be_empty
      ordered_steps.count.should eq 5
    end
    it 'should not be empty' do
      unordered_steps.should_not be_empty
      unordered_steps.count.should eq 5
    end
    it 'should not be null' do
      steps.should_not be_empty
      steps.count.should eq 5
    end
    it "should give me my steps in the order that they follow each other" do
      steps.first.previous_step.should be_blank
      previous_id = steps.first.id
      steps.tail.each do |step|
        step.previous_step.should eq Itps::Escrows::Step.find previous_id
        previous_id = step.id
      end
    end
  end

  describe "#last_step" do
    before do
      @step = JewFactory::Escrows::Step.mock
      @escrow = @step.escrow
    end
    it 'should be a valid step' do
      @step.should be_a Itps::Escrows::Step
      @step.should be_persisted
    end
    it 'should be a valid escrow' do
      @escrow.should be_a Itps::Escrow
      @escrow.should be_persisted
    end
    it "should reference to the only step in the escrow" do
      @escrow.steps.should_not be_empty
      @escrow.steps.first.previous_id.should be_blank
      @escrow.last_step.should eq @step
    end
    it 'should be able to refer to the proper step' do
      @escrow.steps.should_not be_empty
      @step.should be_present
      @escrow.steps.should include @step
    end
    it 'should have no following id given that it is the only step' do
      @step.previous_id.should be_blank
    end
  end
end