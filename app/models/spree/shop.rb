class Spree::Shop < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :address, class_name: 'Spree::Address'
  has_many :listings, class_name: 'Spree::Listing'
  has_many :stockpiles, class_name: 'Spree::Stockpile', through: :listings
  has_many :offers, class_name: 'Spree::Offer'
  has_many :finalizations,
    through: :offers
  has_many :post_transactions,
    through: :finalizations

  has_many :service_supplies
  has_many :service_contracts,
    class_name: 'Spree::ServiceContract'

  has_many :received_ratings,
    class_name: 'Spree::Rating',
    foreign_key: 'shop_id'

  has_many :given_ratings,
    class_name: 'Spree::Rating',
    foreign_key: 'reviewer_id'

  scope :poor_man_search,
    lambda { |name| where "#{self.table_name}.permalink like ?", "%#{name}%" }

  before_validation :_enforce_permalink

  class << self
    # Obviously, cache this result in the nearby future to avoid deat
    def with_most_listings(n=9)
      ids = Spree::Listing.group(:shop_id).sum(:shop_id).to_a.sort do |a,b|
        b.last <=> a.last
      end.map(&:first).take 9
      Spree::Shop.where(id: ids)
    end
  end

  def short_name
    name[0..11]
  end

  def top_listings(n=5)
    listings.sort do |l1,l2|
      l2.latest_offer.created_at <=> l1.latest_offer.created_at
    end.take n
  end

  def latest_received_ratings(n=3) 
    received_ratings.order('created_at desc').limit n
  end

  def latest_given_ratings(n=3) 
    given_ratings.order('created_at desc').limit n
  end

  def top_serviceables(n=5)
    service_contracts.limit(n).map(&:serviceable)
  end

  def top_post_transactions(n=5)
    post_transactions.limit n
  end

  def top_offers(n=5)
    offers.order("created_at desc").limit 5
  end

  def top_finalizations(n=5)
    finalizations.fresh.limit n
  end

  def rating_stars
    received_average_stars.try :ceil
  end

  def rating_score
    _averge_something_on_received { |rating| rating.score }
  end
  alias_method :rating_summary_score, :rating_score

  def received_percentage
    received_average_stars.to_f / Spree::Rating.max_possible_stars
  end

  def received_average_stars
    _averge_something_on_received { |rating| rating.stars }
  end

  def rating_trustworthiness_score 
    _averge_something_on_received { |rating| rating.trustworthiness }
  end

  def rating_simplicity_score 
    _averge_something_on_received { |rating| rating.simplicity }
  end

  def rating_agreeability_score 
    _averge_something_on_received { |rating| rating.agreeability }
  end

  def given_stars
    received_average_stars.try :ceil
  end

  def given_score
    _average_something_on_given { |rating| rating.score }
  end
  alias_method :given_summary_score, :given_score

  def given_percentage
    given_average_stars.to_f / Spree::Rating.max_possible_stars
  end

  def given_average_stars
    _average_something_on_given { |rating| rating.stars }
  end

  def given_trustworthiness_score 
    _average_something_on_given { |rating| rating.trustworthiness }
  end

  def given_simplicity_score 
    _average_something_on_given { |rating| rating.simplicity }
  end

  def given_agreeability_score 
    _average_something_on_given { |rating| rating.agreeability }
  end


  private

  def _enforce_permalink
    self.permalink = self.name.to_url
  end

  def _averge_something_on_received(n=nil, &block)
    return if received_ratings.blank?
    n ||= received_ratings.count
    return yield(received_ratings.first) if 0 >= n
    _averge_something_on_received(n-1, &block) * ( 1 - 1.0 / n) + yield(received_ratings[n-1]) / n.to_f
  end

  def _average_something_on_given(n=nil, &block)
    return if given_ratings.blank?
    n ||= given_ratings.count
    return yield(given_ratings.first) if 0 >= n
    _average_something_on_given(n-1, &block) * ( 1 - 1.0 / n) + yield(given_ratings[n-1]) / n.to_f
  end



end
