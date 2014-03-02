class AddDraftToItpsContracts < ActiveRecord::Migration
  def change
    add_reference :itps_contracts, :draft, index: true
  end
end
