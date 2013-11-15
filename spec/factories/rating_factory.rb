class ChineseFactory::Rating < ChineseFactory::Base
  attr_accessor :reviewed, :reviewer, :reviewable

  def belongs_to(thing)
    tap do |f|
      f.reviewed = thing if thing.is_a? Spree::Shop
      f.reviewable = thing if thing.is_a? Spree::Finalization
      f.reviewable = thing if thing.is_a? Spree::PostTransaction
    end
  end

  def initialize
    @reviewed = ChineseFactory::Shop.mock
    @reviewer = ChineseFactory::Shop.mock
    @reviewable = ChineseFactory::Reviewable.mock
  end

  def attributes
    {
      trustworthiness: rand(100),
      simplicity: rand(100),
      agreeability: rand(100),
      notes: Faker::Lorem.paragraph(2),
      reviewed: reviewed,
      reviewer: reviewer,
      reviewable: reviewable
    }
  end
end