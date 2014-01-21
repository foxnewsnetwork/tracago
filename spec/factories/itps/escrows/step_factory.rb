# == Schema Information
#
# Table name: itps_escrows_steps
#
#  id           :integer          not null, primary key
#  escrow_id    :integer          not null
#  title        :string(255)      not null
#  permalink    :string(255)      not null
#  instructions :text             not null
#  completed_at :datetime
#  position     :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  previous_id  :integer
#  class_name   :string(255)
#

class JewFactory::Escrows::Step < JewFactory::Base
  attr_accessor :escrow

  def initialize
    self.escrow = JewFactory::Escrow.mock
  end

  def belongs_to(thing)
    tap do |f|
      f.escrow = thing if thing.is_a? Itps::Escrow
    end
  end

  def attributes
    {
      escrow: escrow,
      title: Faker::Company.bs,
      instructions: Faker::Lorem.paragraph
    }
  end
end
