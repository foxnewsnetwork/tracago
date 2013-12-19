class Itps::Escrows::Document < ActiveRecord::Base
  belongs_to :step,
    class_name: 'Itps::Escrows::Step'
  before_validation :_create_permalink

  private
  def _create_permalink
    self.permalink ||= "#{title.to_url}-#{_scrambled_datekey}"
  end

  def _scrambled_datekey
    [step.id, Time.now].map(&:to_i).map(&:to_alphabet).join("-doc-")
  end
end