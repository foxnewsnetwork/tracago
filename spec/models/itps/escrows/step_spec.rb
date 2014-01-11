# == Schema Information
#
# Table name: itps_escrows_steps
#
#  id           :integer          not null, primary key
#  escrow_id    :integer          not null
#  title        :string(255)      not null
#  permalink    :string(255)      not null
#  instructions :text             not null
#  completed_at :datetime
#  position     :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  previous_id  :integer
#

require 'spec_helper'

describe Itps::Escrows::Step do
  before do
    @escrow = JewFactory::Escrow.mock
    @steps = (0..2).map { JewFactory::Escrows::Step.belongs_to(Itps::Escrow.find @escrow.id).mock }
  end
  let(:escrow) { Itps::Escrow.find @escrow.id }
  describe '::swap_positions' do
    let(:stepa) { @steps.first }
    let(:stepb) { @steps.third }
    it 'should properly swap their positions' do
      Itps::Escrows::Step.swap_positions stepa, stepb
      stepb2 = Itps::Escrows::Step.find stepb.id
      stepa2 = Itps::Escrows::Step.find stepa.id
      stepb2.previous_step.should be_blank
      stepb2.next_step.should eq stepa.next_step
      stepa2.previous_step.should eq stepb.previous_step
      stepa2.next_step.should be_blank
    end
  end
  describe '#steps' do
    it 'should properly create steps attached to the given escrow' do
      escrow.steps.should eq @steps
    end
    it 'should successful traverse in the order of the linked list' do
      step = @steps.first
      @escrow.ordered_steps.first.should eq step
      @escrow.ordered_steps.second.should eq step.next_step
      @escrow.ordered_steps.third.should eq step.next_step.next_step
    end
  end
  describe '#create' do
    it 'should something' do
      e = JewFactory::Escrow.mock
      e.last_step.should be_blank
      s = JewFactory::Escrows::Step.belongs_to(e).mock
      e = Itps::Escrow.find e.id
      e.last_step.should eq s
      s2 = JewFactory::Escrows::Step.belongs_to(e).mock
      e = Itps::Escrow.find e.id
      e.last_step.should eq s2
      s3 = JewFactory::Escrows::Step.belongs_to(e).mock
      e = Itps::Escrow.find e.id
      e.last_step.should eq s3

      e.ordered_steps.first.should eq s
      e.ordered_steps.second.should eq s2
      e.ordered_steps.third.should eq s3
    end
  end
  describe "#swap_up" do
    let(:steps) { escrow.ordered_steps }
    let(:step) { steps.first }
    let(:second_step) { steps.second }
    it 'should switch the order of the given steps' do
      second_step.swap_up!
      e = Itps::Escrow.find escrow.id
      e.ordered_steps.first.should eq second_step
      e.ordered_steps.second.should eq step
    end
    it 'should give me the first step' do
      step.should be_a Itps::Escrows::Step
      step.previous_step.should be_blank
    end
    it 'should be in linked list order' do
      steps.count.should eq 3
      steps.second.previous_step.should eq steps.first
      steps.third.previous_step.should eq steps.second
    end
  end
end
