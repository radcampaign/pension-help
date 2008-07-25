class ModifyIsResolvedInFeedbacks < ActiveRecord::Migration
  def self.up
    change_column_default(:feedbacks, :is_resolved, false)
  end

  def self.down

  end
end
