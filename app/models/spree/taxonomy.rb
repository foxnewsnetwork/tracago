class Spree::Taxonomy < ActiveRecord::Base
  validates :name, presence: true

  has_many :taxons,
    class_name: 'Spree::Taxon'
  has_many :child_taxons,
    -> { where "parent_id is not null" },
    class_name: 'Spree::Taxon'
  has_one :root, 
    -> { where parent_id: nil }, 
    class_name: "Spree::Taxon", 
    dependent: :destroy

  after_save :set_name

  default_scope -> { order("#{self.table_name}.position") }

  def set_name
    if root
      root.update_column(:name, name)
    else
      self.root = Spree::Taxon.create!(taxonomy_id: id, name: name)
    end
  end

end
