class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :phone, :string
      t.column :availability, :string
      t.column :category, :string
      t.column :feedback, :text
      t.column :is_resolved, :boolean
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
