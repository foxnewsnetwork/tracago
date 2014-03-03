class AddChecksumToItpsContracts < ActiveRecord::Migration
  def change
    add_column :itps_contracts, :checksum, :string
  end
end
