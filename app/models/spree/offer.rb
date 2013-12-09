class Spree::Offer < ActiveRecord::Base
  class OfferTransactionValidator < ::ActiveModel::Validator
    def validate(model)
      model.errors.add :offer, "already accepted" if model.accepted?
    end
  end
  acts_as_paranoid
  FAS = "FAS"
  CNF = "CNF"
  CIF = "CIF"
  FOB = "FOB"
  EXWORKS = "EXWORKS"
  Terms = [FAS, CNF, CIF, FOB, EXWORKS]

  Container = "CONTAINER"
  Flatbed = "FLATBED"
  TransportMethods = [Container, Flatbed]
  PoundsPerContainer = 40000

  belongs_to :shop
  belongs_to :buyer,
    class_name: 'Spree::Shop',
    foreign_key: 'shop_id'
  belongs_to :listing
  belongs_to :address

  belongs_to :destination, 
    class_name: 'Spree::Address',
    foreign_key: 'address_id'

  has_one :origination,
    class_name: 'Spree::Address',
    through: :listing

  has_one :stockpile,
    through: :listing

  has_many :finalizations,
    class_name: 'Spree::Finalization'

  has_many :comments

  validates :listing_id, presence: true
  validates :transport_method, 
    presence: true,
    inclusion: { in: TransportMethods }
  validates :shipping_terms,
    presence: true,
    inclusion: { in: Terms }
  validates :usd_per_pound,
    presence: true,
    numericality: { greater_than: 0 }
  validates_with OfferTransactionValidator
  before_validation :_upcase_transport_method
  delegate :name, :to => :listing

  scope :destined,
    -> { where("#{self.table_name}.address_id is not null") }
  scope :possessed,
    -> { where "#{self.table_name}.shop_id is not null" }
  scope :relevant,
    -> { where "#{self.table_name}.listing_id is not null" }
  scope :fresh,
    -> { where("#{self.table_name}.expires_at is null or expires_at > ?", Time.now) }
  scope :completed,
    -> { destined.possessed.relevant.fresh }

  scope :aimless,
    -> { where("#{self.table_name}.address_id is null") }
  scope :disowned,
    -> { where("#{self.table_name}.shop_id is null") }
  scope :irrelevant,
    -> { where("#{self.table_name}.listing_id is null") }
  scope :moldy,
    -> { where("#{self.table_name}.expires_at < ?", Time.now) }
  scope :utter_crap,
    -> { where("address_id is null or shop_id is null or listing_id is null or expires_at < ?", Time.now) }
  attr_accessor :metadata
  
  def expires_at_as_date
    expires_at.blank? ? I18n.t(:never) : expires_at.to_formatted_s(:long)
  end

  def minimum_weight_presentation
    minimum_pounds_per_load.blank? ? I18n.t(:as_heavy_as_possible) : minimum_pounds_per_load.to_i
  end

  def total_usd
    reasonable_load_count * usd_per_pound * PoundsPerContainer
  end

  def shop_name
    shop.try(:name)
  end

  def fresh_finalization
    finalizations.fresh.order("created_at desc").first
  end

  def acceptable?
    complete? && !accepted?
  end

  def accepted?
    fresh_finalization.present?
  end

  def presentable_updated_at
    updated_at.to_formatted_s(:long)
  end

  def presentable_expires_at
    expires_at.blank? ? Spree.t(:never) : expires_at.to_formatted_s(:long)
  end

  def presentable_minimum_weight
    minimum_pounds_per_load.blank? ? Spree.t(:unspecified) : (minimum_pounds_per_load + " lbs")
  end

  def seller
    listing.shop
  end

  def reasonable_load_count
    return positive_load_count if positive_load_count < _fractional_max_containers
    _fractional_max_containers
  end

  def presentable_quantity
    [reasonable_load_count.to_i.to_s, 
      transport_method.downcase.pluralize(reasonable_load_count)].join " "
  end

  def to_summary
    [
      presentable_quantity,
      "$#{usd_per_pound}",
      "/ lbs",
      _shipping_summary
    ].join " "
  end

  def positive_load_count
    return loads.to_i unless loads.to_i.zero?
    _fractional_max_containers
  end

  def requires_destination?
    destination.blank?
  end

  def requires_buyer?
    shop.blank?
  end

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update! confirmed_at: DateTime.now
  end

  def complete?
    !incomplete?
  end

  def incomplete?
    requires_destination? || requires_buyer?
  end

  def expired?
    Time.now > _expiration_date
  end

  def shipping_summary
    _shipping_summary
  end

  private

  def _upcase_transport_method
    self.transport_method = transport_method.strip.singularize.upcase
  end

  def _fractional_max_containers
    listing.pounds_on_hand.to_f / PoundsPerContainer
  end

  def _expiration_date
    expires_at.blank? ? 1000.years.from_now : expires_at
  end

  def _shipping_summary
    return shipping_terms if shipping_terms == EXWORKS
    "#{shipping_terms} #{destination.try :permalink_name}"
  end
end
