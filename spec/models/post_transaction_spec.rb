require 'spec_helper'

describe Spree::PostTransaction do
  let(:post_transaction) { ChineseFactory::PostTransaction.mock }
  describe '#shitty?' do
    it 'should by default be shitty?' do
      post_transaction.should be_shitty
    end
  end
  describe '#close!' do
    it 'should no longer be shitty after being closed' do
      post_transaction.closed_at.should be_blank
      post_transaction.close!
      post_transaction.reload
      post_transaction.closed_at.should be_present
      post_transaction.closed_at.should < Time.now
      post_transaction.should_not be_shitty
    end
  end
end