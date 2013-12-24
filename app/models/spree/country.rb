# == Schema Information
#
# Table name: spree_countries
#
#  id                 :integer          not null, primary key
#  iso                :string(255)
#  iso3               :string(255)
#  permalink          :string(255)      not null
#  romanized_name     :string(255)
#  local_presentation :string(255)
#  numcode            :string(255)
#  updated_at         :datetime
#

class Spree::Country < ActiveRecord::Base
  include ::Spree::Optionable
  extend ::Spree::Normalizable
  has_many :states, -> { order('name ASC') }

  validates :romanized_name, :permalink, presence: true
  has_many :states,
    class_name: 'Spree::State',
    primary_key: 'permalink',
    foreign_key: 'country_permalink'
  has_many :cities,
    class_name: 'Spree::City',
    through: :states
  has_many :addresses,
    class_name: 'Spree::Address',
    through: :states
  has_many :stockpiles,
    through: :states,
    class_name: 'Spree::Stockpile'
  has_many :listings,
    through: :states,
    class_name: 'Spree::Listing'

  before_validation :_enforce_permalink
    
  class << self

    def all_names
      @_everybody ||= select("distinct romanized_name").map(&:romanized_name).sort.uniq.unshift "United States"
    end

  end

  def <=>(other)
    romanized_name <=> other.romanized_name
  end

  def to_s
    romanized_name
  end

  def name
    romanized_name
  end

  def presentation
    return local_presentation if local_presentation.present?
    romanized_name
  end

  private

  def _enforce_permalink
    self.permalink = romanized_name.downcase.split('').select { |l| /[a-z]/ =~ l }.join
  end
end
