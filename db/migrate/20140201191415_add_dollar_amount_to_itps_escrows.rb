class AddDollarAmountToItpsEscrows < ActiveRecord::Migration
  def change
    add_column :itps_escrows, :dollar_amount, :decimal, precision: 16, scale: 2
  end
end
