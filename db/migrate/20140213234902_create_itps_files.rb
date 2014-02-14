class CreateItpsFiles < ActiveRecord::Migration
  def change
    create_table :itps_files do |t|
      t.string :permalink, null: false, index: true
      t.timestamps
    end
  end
end
