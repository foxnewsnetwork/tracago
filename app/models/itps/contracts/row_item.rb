class Itps::Contracts::RowItem # Note, this is NOT ActiveRecord
  attr_hash_accessor :name, :quantity, :unit_cost

  def total_cost
    quantity.to_f * unit_cost.to_f
  end
end