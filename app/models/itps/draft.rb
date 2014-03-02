# == Schema Information
#
# Table name: itps_drafts
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  permalink      :string(255)      not null
#  content        :text
#  created_at     :datetime
#  updated_at     :datetime
#  class_name     :string(255)
#  last_step_name :string(255)
#

class Itps::Draft < ActiveRecord::Base
  self.table_name = 'itps_drafts'
  belongs_to :account,
    class_name: 'Itps::Account'

  has_many :items,
    class_name: "Itps::Drafts::Item"

  has_many :punishments,
    class_name: 'Itps::Drafts::Punishment'

  has_many :unordered_packing_weight_punishments,
    -> { packing_weights },
    class_name: 'Itps::Drafts::Punishment'

  has_many :unordered_container_count_punishments,
    -> { containers },
    class_name: 'Itps::Drafts::Punishment'
  
  has_many :packing_weight_punishments,
    -> { packing_weights.order('maximum_quantity desc') },
    class_name: 'Itps::Drafts::Punishment'

  has_many :container_count_punishments,
    -> { containers.order('maximum_quantity desc') },
    class_name: 'Itps::Drafts::Punishment'

  has_many :contracts,
    class_name: 'Itps::Contract'

  before_create :_create_permalink
  class << self
    def create_from_hash!(hash)
      create! content: hash.to_yaml
    end
  end

  def minimum_packing_weight_before_cancel
    unordered_packing_weight_punishments.order('minimum_quantity asc').limit(1).first.try(:minimum_quantity)
  end

  def minimum_container_count_before_cancel
    unordered_container_count_punishments.order('minimum_quantity asc').limit(1).first.try(:minimum_quantity)
  end

  def minimum_packing_weight_before_punishment
    packing_weight_punishments.limit(1).first.try(:maximum_quantity)
  end

  def minimum_container_count_before_punishment
    container_count_punishments.limit(1).first.try(:maximum_quantity)
  end

  def international?
    true
  end

  def domestic?
    false
  end

  def make_contract!
    downcast.make_contract!
  end

  def short_summary
    "#{updated_at.to_date.to_s}-#{permalink}"
  end

  def update_from_hash!(hash)
    @parsed_hash = nil
    return self if update content: parsed_hash.merge(hash).to_yaml
  end

  def parsed_hash
    _fix_dates YAML.load(content).to_hash
  end

  def total_cost
    items.inject(0) do |cost, item|
      cost + item.total_cost
    end
  end

  private
  def _fix_dates(hash)
    keys = hash.keys.map(&:to_s).select do |key|
      /\(\d+i\)$/ =~ key
    end
    hash.access_map!(*keys.map(&:to_sym), &:to_i)
  end

  def _create_permalink
    self.permalink = "#{rand 999999}-#{Faker::Lorem.word}-#{DateTime.now.to_i.to_alphabet}".to_url
  end
end
