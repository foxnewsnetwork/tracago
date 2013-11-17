module Spree
  class Address < ActiveRecord::Base
    belongs_to :country, class_name: "Spree::Country"
    belongs_to :state, class_name: "Spree::State"

    validates :address1, :city, :country, presence: true
    validates_with Spree::Addresses::Validator

    alias_attribute :first_name, :firstname
    alias_attribute :last_name, :lastname

    CoreAttributes = [:address1, :address2, :city, :state, :country]
    class << self
      def roughup_params(params)
        a = params.to_a.filter_map do |kv|
          :state.to_s == kv.first.to_s
        end.call do |kv|
          [:state_id, Spree::State.normalize!(kv.last).id]
        end.filter_map do |kv|
          :country.to_s == kv.first.to_s
        end.call do |kv|
          [:country_id, Spree::Country.normalize!(kv.last).id]
        end
        Hash[a]
      end

      def find_roughly_or_create_by(params)
        find_or_create_by roughup_params params
      end

      def default
        country = Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
        new(country: country)
      end
    end

    # Can modify an address if it's not been used in an order (but checkouts controller has finer control)
    # def editable?
    #   new_record? || (shipments.empty? && checkouts.empty?)
    # end

    def inspect
      [address1, address2, city, state.try(:name), country.iso].reject(&:blank?).map(&:upcase).join " "
    end

    def permalink_name
      "#{state.try(:name) || country.iso} - #{city}".strip.downcase
    end

    def full_name
      "#{firstname} #{lastname}".strip
    end

    def state_text
      state.try(:abbr) || state.try(:name) || state_name
    end

    def same_as?(other)
      return false if other.nil?
      attributes.except('id', 'updated_at', 'created_at') == other.attributes.except('id', 'updated_at', 'created_at')
    end

    alias same_as same_as?

    def to_s
      "#{full_name}: #{address1}"
    end

    def clone
      self.class.new(self.attributes.except('id', 'updated_at', 'created_at'))
    end

    def ==(other_address)
      self_attrs = self.attributes
      other_attrs = other_address.respond_to?(:attributes) ? other_address.attributes : {}

      [self_attrs, other_attrs].each { |attrs| attrs.except!('id', 'created_at', 'updated_at', 'order_id') }

      self_attrs == other_attrs
    end

    def empty?
      attributes.except('id', 'created_at', 'updated_at', 'order_id', 'country_id').all? { |_, v| v.nil? }
    end

    # Generates an ActiveMerchant compatible address hash
    def active_merchant_hash
      {
        name: full_name,
        address1: address1,
        address2: address2,
        city: city,
        state: state_text,
        zip: zipcode,
        country: country.try(:iso),
        phone: phone
      }
    end

  end
end
