# == Schema Information
#
# Table name: itps_drafts
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  permalink      :string(255)      not null
#  content        :text
#  created_at     :datetime
#  updated_at     :datetime
#  class_name     :string(255)
#  last_step_name :string(255)
#

require 'spec_helper'

describe Itps::Draft do
  describe '#make_contract!' do
    
  end
end
