class AddClaimedAtToItpsEscrows < ActiveRecord::Migration
  def change
    add_column :itps_escrows, :claimed_at, :datetime
  end
end
