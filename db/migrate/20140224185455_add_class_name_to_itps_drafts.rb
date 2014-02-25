class AddClassNameToItpsDrafts < ActiveRecord::Migration
  def change
    add_column :itps_drafts, :class_name, :string
  end
end
