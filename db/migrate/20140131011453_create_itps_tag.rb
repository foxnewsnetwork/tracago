class CreateItpsTag < ActiveRecord::Migration
  def change
    create_table :itps_tags do |t|
      t.string :permalink, null: false
      t.string :presentation, null: false
    end
    add_index :itps_tags, [:permalink], unique: true
  end
end
