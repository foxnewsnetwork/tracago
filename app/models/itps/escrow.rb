class Itps::Escrow < ActiveRecord::Base
  acts_as_paranoid
  has_many :steps,
    class_name: 'Itps::Escrows::Step'
  has_one :last_step,
    -> { order("#{self.table_name}.position desc").limit(1) },
    class_name: 'Itps::Escrows::Step'
  belongs_to :payment_party,
    class_name: 'Itps::Party'
  belongs_to :service_party,
    class_name: 'Itps::Party'

  before_validation :_create_permalink

  def status
    return :deleted if deleted?
    return :closed if closed?
    return :opened if opened?
    return :unready
  end

  def opened?
    opened_at.present?
  end

  def closed?
    closed_at.present?
  end

  private
  def _create_permalink
    self.permalink ||= "#{DateTime.now.to_s}-#{payment_party.permalink}-#{service_party.permalink}"
  end
end