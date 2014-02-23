# == Schema Information
#
# Table name: itps_contracts
#
#  id              :integer          not null, primary key
#  escrow_id       :integer
#  permalink       :string(255)      not null
#  class_name      :string(255)
#  introduction    :string(255)
#  content_summary :text
#  expires_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Itps::Contracts::Shipping < Itps::Contract
  self.table_name = 'itps_contracts'
  # pos should be an array of hashes of item, quantity, unit_cost
  def row_items=(*row_items)
    @row_items = nil
    self.content_summary = row_items.to_yaml
  end

  def row_items
    @row_items ||= YAML.load(content_summary).map do |array|
      Itps::Contracts::RowItem.new *array
    end
  end

  def total_cost
    row_items.map(&:total_cost).reduce(&:+)
  end
end
