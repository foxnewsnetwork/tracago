# == Schema Information
#
# Table name: spree_states
#
#  id                 :integer          not null, primary key
#  romanized_name     :string(255)
#  abbr               :string(255)
#  permalink          :string(255)      not null
#  local_presentation :string(255)
#  country_permalink  :string(255)
#  updated_at         :datetime
#

class Spree::State < ActiveRecord::Base
  include ::Spree::Optionable
  extend ::Spree::Normalizable
  belongs_to :country, 
    class_name: 'Spree::Country',
    foreign_key: 'country_permalink',
    primary_key: 'permalink'

  validates :country, presence: true

  has_many :cities,
    class_name: 'Spree::City'

  has_many :addresses,
    class_name: 'Spree::Address',
    through: :cities

  has_many :stockpiles,
    class_name: 'Spree::Stockpile',
    through: :cities

  has_many :listings,
    class_name: 'Spree::Listing',
    through: :cities

  before_validation :_enforce_permalink

  class << self

    def all_names
      @_everybody ||= select("distinct romanized_name").map(&:name).sort.uniq
    end

    # table of { country.id => [ state.id , state.name ] }, arrays sorted by name
    # blank is added elsewhere, if needed
    def states_group_by_country_id
      state_info = Hash.new { |h, k| h[k] = [] }
      self.order('name ASC').each { |state|
        state_info[state.country_id.to_s].push [state.id, state.name]
      }
      state_info
    end
  end

  def full_romanization
    [romanized_name, country.romanized_name].join ", "
  end

  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end

  def name
    romanized_name
  end

  private

  def _enforce_permalink
    self.permalink = [country.permalink, _stripped_romanized_name].join("-")
  end

  def _stripped_romanized_name
    romanized_name.downcase.split("").select { |l| /[a-z]/ =~ l }.join
  end
end
