class CreateItpsEmailArchivesSerializedObjects < ActiveRecord::Migration
  def change
    create_table :itps_email_archives_serialized_objects do |t|
      t.references :email_archive, index: true, null: false
      t.integer :order_number, null: false, default: 0
      t.string :name_of_model, null: false
      t.string :variable_namekey, null: false
      t.string :external_model_id, null: false
    end
  end
end
