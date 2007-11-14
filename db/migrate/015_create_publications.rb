class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.column :name, :string
      t.column :plan_id, :integer
      t.column :phone, :string, :limit => 20
      t.column :phone_ext, :string, :limit => 10
      t.column :tollfree, :string, :limit => 20
      t.column :tollfree_ext, :string, :limit => 10
      t.column :fax, :string, :limit => 20
      t.column :tty, :string, :limit => 20
      t.column :tty_ext, :string, :limit => 10
      t.column :email, :string
      t.column :url, :string
      t.column :url_title, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :publications
  end
end
