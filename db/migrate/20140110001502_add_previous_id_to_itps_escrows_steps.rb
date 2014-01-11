class AddPreviousIdToItpsEscrowsSteps < ActiveRecord::Migration
  def change
    add_column :itps_escrows_steps, :previous_id, :integer
    add_index :itps_escrows_steps, [:previous_id]
  end
end
