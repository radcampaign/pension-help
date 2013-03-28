class AddStateToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :state_abbrev, :string, :limit => 2
  end

  def self.down
    remove_column :feedbacks, :state_abbrev
  end
end
