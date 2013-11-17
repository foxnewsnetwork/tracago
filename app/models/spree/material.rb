module Spree
  class Material < ActiveRecord::Base
    acts_as_paranoid
    has_many :stockpiles, class_name: 'Spree::Stockpile'
    has_many :images, 
      -> { order(:position) }, 
      as: :viewable, 
      dependent: :destroy, 
      class_name: "Spree::Image"
    validates :name, presence: true
    validates :permalink, presence: true

    before_validation :_make_permalink
    before_destroy :_punch_permalink

    class << self
      def all_as_options_array
        @_all_as_options_array ||= all.map(&:to_options_array)
      end

      def normalize!(id_name_permalink)
        return id_name_permalink if id_name_permalink.is_a? self
        return find(id_name_permalink) if id_name_permalink.is_a? Integer
        find_by_permalink(id_name_permalink) ||
        find_by_name(id_name_permalink) || 
        find_by_id!(id_name_permalink)
      end

      def normalize(id_name_permalink)
        return id_name_permalink if id_name_permalink.is_a? self
        return find(id_name_permalink) if id_name_permalink.is_a? Integer
        find_by_permalink(id_name_permalink) ||
        find_by_name(id_name_permalink) || 
        find_by_id(id_name_permalink)
      end
    end

    def to_options_array
      [name, id]
    end

    private
    def _make_permalink
      self.permalink = name.to_s.split('').map(&:downcase).select do |char|
        char =~ /[a-z]/
      end.join
    end

    def _punch_permalink
      update_attribute :permalink, "#{Time.now.to_i}_#{permalink}" # punch permalink with date prefix
    end
  end
end

