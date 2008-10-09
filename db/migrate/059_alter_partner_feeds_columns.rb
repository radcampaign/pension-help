class AlterPartnerFeedsColumns < ActiveRecord::Migration
  def self.up
    change_column :partners, :consultation_fee, :decimal, :precision => 10, :scale => 2
    change_column :partners, :hourly_rate, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    change_column :partners, :consultation_fee, :string
    change_column :partners, :hourly_rate, :integer
  end
end
