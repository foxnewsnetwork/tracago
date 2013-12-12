class Spree::Finalization < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :offer,
    class_name: 'Spree::Offer'
  has_one :post_transaction,
    class_name: 'Spree::PostTransaction'
  has_many :service_demands,
    class_name: 'Spree::ServiceDemand'
  has_many :service_contracts,
    class_name: 'Spree::ServiceContract'
  has_many :serviceables,
    through: :service_contacts,
    source_type: 'Spree::Serviceable'
  has_many :escrow_steps,
    class_name: 'Spree::EscrowStep'
  delegate :destination,
    :origination,
    :buyer,
    :seller,
    to: :offer
  
  has_many :ratings, as: :reviewable    
  scope :fresh, 
    -> { where "#{self.table_name}.expires_at is null or #{self.table_name}.expires_at > ?", Time.now }

  def escrow_steps_with_all_defaults
    @escrow_steps ||= escrow_steps_without_all_defaults
    if @escrow_steps.blank?
      @escrow_steps = _default_steps
    else
      @escrow_steps
    end
  end
  alias_method_chain :escrow_steps, :all_defaults

  def downcast_escrow_steps
    escrow_steps.map(&:downcast).sort do |e1, e2|
      e1.position <=> e2.position
    end
  end

  def expires_at_as_date
    expires_at.blank? ? I18n.t(:never) : expires_at.to_formatted_s(:long)
  end

  def relevant_shops
    [offer.buyer, offer.seller]
  end

  def fresh?
    Time.now < _expiration_date
  end

  def shitty?
    post_transaction.present? && post_transaction.unresolved?
  end

  private

  def _default_steps
    hashes = Dir[File.join(__dir__, "escrow_steps", "*.rb")].map do |f|
      { finalization: self, filename: f }
    end
    Spree::EscrowStep.create_from_filename hashes
  end

  def _expiration_date
    expires_at || 1000.years.from_now
  end
end

# >last summer
# >working as nurse
# >live next to bad * (genetics + habits) diabetic
# >she's an middle-aged bitter old lady with no apparent family
# >coming home from work 
# >notices her door is ajar
# >notices it's a mess inside
# >alarmed
# >buglary?
# >call out for her
# >no response
# >poke head into her door to try again
# >horrible smell of rotting meat assault me
# >I gag, but manage to call out her name again
# >hear "in here, give me a hand, [anon]" from her bedroom
# >the smell is godawful, but I go in
# >open door to her room
# >smell is 1000x worse
# >480lbs sworl of fat sitting on bed
# >pizza boxes, cheezits, guac, etc. smeared all over the mattress
# >"help me into my rascal" she holds out an extremely grubby food encrusted hand to me
# >I feel disgusted, but I feel really bad for her
# >I walk closer and grab her hand
# >suddenly notice her right foot
# >mfw it's green and black
# >"You need to get to a hospital..." I tell her
# >She grunts in consent while I tug at her hand
# >she pulls on me to try to get up
# >I slip on grease on floor
# >trip forward on her
# >my hand lands on her gangrene'd foot
# >several finger go in disturbingly
# >terrible eldritch deathly smell bursts into the room
# >swear 2 god, I see worms crawling up my arms
# >I scream like a 12 year old
# >stumble up, jump back, slip on pizza, and black out
# >come to moments later
# >coworker from hospital carrying me in his arms
# >ask him to put me down
# >he trolls me nonstop
# >"you've put your foot down?"
# >"glad to see you back on your feet"
# >"that feet when your gotta amputate that feel"