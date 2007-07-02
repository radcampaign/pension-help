# == Schema Information
# Schema version: 8
#
# Table name: help_nets
#
#  id               :integer(11)   not null, primary key
#  contact_id       :integer(11)   
#  exp_erisa_single :boolean(1)    
#  exp_erisa_multi  :boolean(1)    
#  exp_fed          :boolean(1)    
#  exp_state        :boolean(1)    
#  exp_church       :boolean(1)    
#  exp_other        :string(255)   
#  other_info       :string(255)   
#  wont_charge_fees :boolean(1)    
#

class HelpNet < ActiveRecord::Base
  belongs_to :contact
end