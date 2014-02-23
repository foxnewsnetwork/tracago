# == Schema Information
#
# Table name: itps_contracts
#
#  id              :integer          not null, primary key
#  escrow_id       :integer
#  permalink       :string(255)      not null
#  class_name      :string(255)
#  introduction    :string(255)
#  content_summary :text
#  expires_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Itps::Contract < ActiveRecord::Base
  self.table_name = 'itps_contracts'
  belongs_to :escrow,
    class_name: 'Itps::Escrow'

  before_create :_create_permalink

  def downcast
    return self if class_name.blank?
    _child_class.find id
  end

  private
  def _child_class
    Itps::Contracts.const_get class_name.to_s.camelcase
  end
  def _create_permalink
    self.permalink = "#{DateTime.now.to_i.to_alphabet}-#{class_name.to_s}-#{rand 999999}".to_url
  end
end
