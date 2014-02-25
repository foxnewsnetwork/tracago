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
  before_create :_create_permalink
  class << self
    def create_from_hash!(hash)
      create! content: hash.to_yaml
    end
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
    YAML.load(content).to_hash
  end

  def total_cost
    items.inject(0) do |cost, item|
      cost + item.total_cost
    end
  end

  private
  def _create_permalink
    self.permalink = "#{rand 999999}-#{Faker::Lorem.word}-#{DateTime.now.to_i.to_alphabet}".to_url
  end
end
