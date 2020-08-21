class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.string :title
      t.text :content
      t.string :author_ip
      t.float :avg_rating, precision: 4, scale: 1, default: 0.0

      t.timestamps
    end
  end
end
