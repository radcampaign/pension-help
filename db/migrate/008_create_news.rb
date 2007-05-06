class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :title, :string
      t.column :intro, :text
      t.column :article_url, :string
      t.column :source_url, :string
      t.column :is_internal, :boolean
      t.column :body, :text
      t.column "publish_date", :date
      t.column "archive_date", :date
      t.column "created_at", :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :news
  end
end
