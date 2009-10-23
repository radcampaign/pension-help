class AddReferralFeeDescriptions < ActiveRecord::Migration
  def self.up
    add_column :partners, :consultation_fee_desc, :string 
    add_column :partners, :hourly_rate_desc, :string 
    add_column :partners, :fee_shifting_desc, :string 
    
    add_column :referral_fees, :use_for_pal, :boolean, :default => 1
    
    execute "insert into referral_fees (name, position, use_for_pal) values ('Initial Consultation Fee:',1,1),('Hourly Rate:',2,1)"
    execute "update referral_fees set name='Contingency fee.',position=3 where name like '%Contingency fee%'"
    execute "update referral_fees set name='Fee-Shifting, as appropriate.', position=4, use_for_pal=0 where name like '%fee shifting%'"
    execute "update referral_fees set name='Pro Bono, Reduced Rate or Sliding Scale. As appropriate, based on need.', position=5 where name like '%Reduced fee%'"
    
    
  end

  def self.down
    remove_column :partners, :consultation_fee_desc
    remove_column :partners, :hourly_rate_desc 
    remove_column :partners, :fee_shifting_desc

    remove_column :referral_fees, :use_for_pal, :boolean
  end
end
