class CreatePageEmails < ActiveRecord::Migration
  def self.up
    create_table :page_emails, :force => true do |t|
      t.column :page_title,                 :string
      t.column :link,                       :string
      t.column :name,                       :string
      t.column :email,                      :string
      t.column :recipient_name,             :string
      t.column :recipient_email,            :string
      t.column :message,                   :text
      t.column :created_at,                 :datetime
      t.column :updated_at,                 :datetime
    end
  end

  def self.down
    drop_table :page_emails
  end
end
