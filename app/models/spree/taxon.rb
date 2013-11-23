class Spree::Taxon < ActiveRecord::Base
  belongs_to :parent,
    class_name: 'Spree::Taxon'

  belongs_to :taxonomy, 
    class_name: 'Spree::Taxonomy', 
    touch: true

  has_many :children,
    class_name: 'Spree::Taxon',
    foreign_key: 'parent_id'

  has_many :abelian_groups, dependent: :delete_all
  has_many :stockpiles, through: :abelian_groups

  before_create :set_permalink

  validates :name, presence: true

  has_attached_file :icon,
    styles: { mini: '32x32>', normal: '128x128>' },
    default_style: :mini,
    url: '/spree/taxons/:id/:style/:basename.:extension',
    path: ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
    default_url: '/assets/default_taxon.png'

  class << self
    def plastics
      @plastics ||= Spree::Taxonomy.find_by_name!("Categories").child_taxons
    end
  end


  # Return meta_title if set otherwise generates from root name and/or taxon name
  def seo_title
    if meta_title
      meta_title
    else
      root? ? name : "#{root.name} - #{name}"
    end
  end

  # Creates permalink based on Stringex's .to_url method
  def set_permalink
    if parent.present?
      self.permalink = [parent.permalink, (permalink.blank? ? name.to_url : permalink.split('/').last)].join('/')
    else
      self.permalink = name.to_url if permalink.blank?
    end
  end

  # For #2759
  def to_param
    permalink
  end

  def active_products
    scope = products.active
    scope
  end

  def pretty_name
    ancestor_chain = self.ancestors.inject("") do |name, ancestor|
      name += "#{ancestor.name} -> "
    end
    ancestor_chain + "#{name}"
  end

end
