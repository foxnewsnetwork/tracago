class Spree::City < ActiveRecord::Base
  include ::Spree::Optionable
  extend ::Spree::Normalizable  
  belongs_to :state,
    class_name: 'Spree::State'

  has_one :country,
    through: :state,
    class_name: 'Spree::Country'

  has_many :addresses,
    class_name: 'Spree::Address',
    foreign_key: 'city_permalink',
    primary_key: "permalink"

  has_many :stockpiles,
    through: :addresses,
    class_name: 'Spree::Stockpile'

  has_many :listings,
    through: :stockpiles,
    class_name: 'Spree::Listing'

  before_validation :_create_permalink
  validates :permalink, uniqueness: true, presence: true

  def full_romanization
    [romanized_name, state.full_romanization].join ", "
  end

  def permalink_name
    permalink.split("-").reverse.join(", ")
  end
  private

  def _create_permalink
    self.permalink = [state.permalink, _name_to_permalink].join("-").to_url
  end

  def _name_to_permalink
    romanized_name.downcase.split("").select { |letter| /[a-z]/ =~ letter }.join.to_url
  end
end
