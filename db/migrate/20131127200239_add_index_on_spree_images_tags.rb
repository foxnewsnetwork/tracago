class AddIndexOnSpreeImagesTags < ActiveRecord::Migration
  def change
    add_index :spree_tags_images, [:image_id]
  end
end
