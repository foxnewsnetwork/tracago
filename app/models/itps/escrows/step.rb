class Itps::Escrows::Step < ActiveRecord::Base
  belongs_to :escrow,
    class_name: 'Itps::Escrow'
  has_many :documents,
    class_name: 'Itps::Escrows::Document'
  before_validation :_create_permalink

  private
  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}"
  end

  def _scrambled_datekey
    [DateTime.now, escrow.id].map(&:to_i).map(&:to_alphabet).join("-step-")
  end
end