# This migration comes from spree (originally 20120831092320)
class SpreeOneTwo < ActiveRecord::Migration
  def change

    create_table :spree_addresses do |t|
      t.string     :fullname
      t.string     :address1
      t.string     :address2
      t.string     :city_permalink
      t.string     :zipcode
      t.string     :phone
      t.string     :alternative_phone
      t.timestamps
    end
    add_index :spree_addresses, [:city_permalink]
    add_index :spree_addresses, [:fullname], :name => 'index_addresses_on_fullname'

    create_table :spree_assets do |t|
      t.references :viewable,               :polymorphic => true
      t.integer    :attachment_width
      t.integer    :attachment_height
      t.integer    :attachment_file_size
      t.integer    :position
      t.string     :attachment_content_type
      t.string     :attachment_file_name
      t.string     :type,                   :limit => 75
      t.datetime   :attachment_updated_at
      t.text       :alt
    end

    add_index :spree_assets, [:viewable_id],          :name => 'index_assets_on_viewable_id'
    add_index :spree_assets, [:viewable_type, :type], :name => 'index_assets_on_viewable_type_and_type'

    create_table :spree_countries do |t|
      t.string  :iso
      t.string  :iso3
      t.string  :permalink, null: false
      t.string  :romanized_name
      t.string  :local_presentation
      t.string :numcode
    end

    add_index :spree_countries, [:permalink], unique: true

    create_table :spree_option_types do |t|
      t.string    :name,         :limit => 100
      t.string    :presentation, :limit => 100
      t.integer   :position,                   :default => 0, :null => false
      t.timestamps
    end

    create_table :spree_option_values do |t|
      t.integer    :position
      t.string     :name
      t.string     :presentation
      t.references :option_type
      t.timestamps
    end

    create_table :spree_preferences do |t|
      t.string     :name, :limit => 100
      t.references :owner, :polymorphic => true
      t.text       :value
      t.string     :key
      t.string     :value_type
      t.timestamps
    end

    add_index :spree_preferences, [:key], :name => 'index_spree_preferences_on_key', :unique => true


    create_table :spree_states do |t|
      t.string     :romanized_name
      t.string     :abbr
      t.string :permalink, null: false
      t.string :local_presentation
      t.string :country_permalink
    end
    add_index :spree_states, [:permalink], unique: true

    create_table :spree_taxonomies do |t|
      t.string     :name, :null => false
      t.integer :position
      t.timestamps
    end

    create_table :spree_taxons do |t|
      t.references :parent
      t.integer    :position,          :default => 0
      t.string     :name,                             :null => false
      t.string     :permalink
      t.references :taxonomy
      t.integer    :lft
      t.integer    :rgt
      t.string     :icon_file_name
      t.string     :icon_content_type
      t.integer    :icon_file_size
      t.datetime   :icon_updated_at
      t.text       :description
      t.timestamps
    end

    add_index :spree_taxons, [:parent_id],   :name => 'index_taxons_on_parent_id'
    add_index :spree_taxons, [:permalink],   :name => 'index_taxons_on_permalink'
    add_index :spree_taxons, [:taxonomy_id], :name => 'index_taxons_on_taxonomy_id'

  
  end
end
