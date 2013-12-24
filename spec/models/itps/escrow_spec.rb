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

