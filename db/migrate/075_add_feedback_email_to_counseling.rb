class AddFeedbackEmailToCounseling < ActiveRecord::Migration
  def self.up
    add_column :counselings, :feedback_email, :string

  end

  def self.down
    remove_column :counselings, :feedback_email
  end
end
