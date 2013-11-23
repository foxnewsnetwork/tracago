class CreateSpreeCities < ActiveRecord::Migration
  def change
    create_table :spree_cities do |t|
      t.references :state, index: true
      t.string :romanized_name, null: false
      t.string :permalink, null: false
      t.string :local_presentation
      t.timestamps
    end
    add_index :spree_cities, [:permalink], unique: true
  end
end
