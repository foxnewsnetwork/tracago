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
#  draft_id        :integer
#

class Itps::Contract < ActiveRecord::Base
  BufferId = 165449
  self.table_name = 'itps_contracts'
  belongs_to :escrow,
    class_name: 'Itps::Escrow'

  before_create :_create_permalink

  belongs_to :draft,
    class_name: 'Itps::Draft'

  has_one :account,
    through: :draft,
    class_name: 'Itps::Account'
  class << self
    def id_to_bullshit_id(id)
      "#{id.to_i * 3 + BufferId}-cc"
    end

    def bullshit_id_to_id(bullshit_id)
      ((bullshit_id.split('-').first.to_i - BufferId) / 3).to_i
    end

    def find_by_permalink_or_bullshit_id!(permalink_or_bs_id)
      find_by_permalink(permalink_or_bs_id) || find_by_bullshit_id!(permalink_or_bs_id)
    end

    def find_by_bullshit_id!(bullshit_id)
      find bullshit_id_to_id permalink_or_bs_id
    end
  end

  def downcast
    return self if class_name.blank?
    _child_class.find id
  end

  def bullshit_id
    self.class.id_to_bullshit_id id
  end

  private
  def _child_class
    Itps::Contracts.const_get class_name.to_s.camelcase
  end
  def _create_permalink
    self.permalink = "#{DateTime.now.to_i.to_alphabet}-#{class_name.to_s}-#{rand 999999}".to_url
  end
end
