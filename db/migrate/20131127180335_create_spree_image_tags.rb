class CreateSpreeImageTags < ActiveRecord::Migration
  def change
    create_table :spree_tags do |t|
      t.string :permalink, null: false
      t.string :presentation, null: false
      t.timestamps
    end
    create_table :spree_tags_images do |t|
      t.references :tag, index: false
      t.references :image, index: false
    end
    add_index :spree_tags_images, 
      [:tag_id, :image_id],
      name: 'idx_on_tags_images_tag_image',
      unique: true
  end
end
