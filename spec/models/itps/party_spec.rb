# == Schema Information
#
# Table name: itps_parties
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  email        :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  permalink    :string(255)      not null
#

require 'spec_helper'

describe Itps::Party do
  context 'account' do
    
  end
end
