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

class Itps::Escrows::PayStep < Itps::Escrows::Step
  self.table_name = 'itps_escrows_steps'

end
