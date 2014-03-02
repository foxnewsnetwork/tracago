class CreateItpsDraftsPunishments < ActiveRecord::Migration
  def change
    create_table :itps_drafts_punishments do |t|
      t.references :draft, index: true
      t.decimal :minimum_quantity, precision: 16, scale: 6
      t.decimal :maximum_quantity, precision: 16, scale: 6
      t.string :comparison_type
      t.string :quantity_unit
      t.decimal :price_deduction, precision: 16, scale: 8
      t.string :price_unit
      t.string :memo
      t.timestamps
    end
  end
end
