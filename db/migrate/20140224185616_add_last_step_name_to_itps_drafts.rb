class AddLastStepNameToItpsDrafts < ActiveRecord::Migration
  def change
    add_column :itps_drafts, :last_step_name, :string
  end
end
