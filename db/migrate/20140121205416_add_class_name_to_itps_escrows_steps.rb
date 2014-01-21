class AddClassNameToItpsEscrowsSteps < ActiveRecord::Migration
  def change
    add_column :itps_escrows_steps, :class_name, :string
  end
end
