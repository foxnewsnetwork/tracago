# == Schema Information
#
# Table name: spree_preferences
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  owner_id   :integer
#  owner_type :string(255)
#  value      :text
#  key        :string(255)
#  value_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Spree::Preference < ActiveRecord::Base
  serialize :value

  validates :key, presence: true
  validates :value_type, presence: true

  belongs_to :user

  scope :valid, -> { where(Spree::Preference.arel_table[:key].not_eq(nil)).where(Spree::Preference.arel_table[:value_type].not_eq(nil)) }

  # The type conversions here should match
  # the ones in spree::preferences::preferrable#convert_preference_value
  def value
    if self[:value_type].present?
      case self[:value_type].to_sym
      when :string, :text
        self[:value].to_s
      when :password
        self[:value].to_s
      when :decimal
        BigDecimal.new(self[:value].to_s).round(2, BigDecimal::ROUND_HALF_UP)
      when :integer
        self[:value].to_i
      when :boolean
        (self[:value].to_s =~ /^[t|1]/i) != nil
      else
        self[:value].is_a?(String) ? YAML.load(self[:value]) : self[:value]
      end
    else
      self[:value]
    end
  end

  def raw_value
    self[:value]
  end
end
