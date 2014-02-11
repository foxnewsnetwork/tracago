class AddPermalinkToItpsParties < ActiveRecord::Migration
  def change
    add_column :itps_parties, :permalink, :string, null: false
    add_index :itps_parties, [:permalink], unique: true
  end
end
