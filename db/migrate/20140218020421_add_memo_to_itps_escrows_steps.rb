class AddMemoToItpsEscrowsSteps < ActiveRecord::Migration
  def change
    add_column :itps_escrows_steps, :memo, :text
  end
end
