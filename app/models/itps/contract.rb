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
#  checksum        :string(255)
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
      find bullshit_id_to_id bullshit_id
    end
  end

  def secret_key
    return escrow.service_party_agree_key if escrow.payment_party_agreed?
    return escrow.payment_party_agree_key if escrow.service_party_agreed?
  end

  def seller_email
    draft.parsed_hash[:seller_email]
  end

  def locked?
    checksum.present? && escrow.present?
  end

  def already_agreed?(account)
    locked? && escrow.already_agreed?(account.party)
  end

  def update_content_summary_and_generate_checksum(content_summary)
    update content_summary: content_summary, checksum: _generate_checksum(content_summary)
  end

  def downcast
    return self if class_name.blank?
    _child_class.find id
  end

  def bullshit_id
    self.class.id_to_bullshit_id id
  end

  def generate_checksum!
    update checksum: _generate_checksum(content_summary)
  end

  private
  def _generate_checksum(text)
    Digest::SHA256.new.hexdigest text.to_s
  end

  def _child_class
    Itps::Contracts.const_get class_name.to_s.camelcase
  end
  def _create_permalink
    self.permalink = "#{DateTime.now.to_i.to_alphabet}-#{class_name.to_s}-#{rand 999999}".to_url
  end
end
