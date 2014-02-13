class CreateItpsEmailArchives < ActiveRecord::Migration
  def change
    create_table :itps_email_archives do |t|
      t.string :mailer_name, null: false
      t.string :mailer_method, null: false
      t.string :destination, null: false
      t.string :origination
      t.string :subject
      t.timestamps
    end
    add_index :itps_email_archives, [:destination]
  end
end
