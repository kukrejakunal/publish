# This migration comes from article (originally 20140223104006)
class CreateArticleArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
