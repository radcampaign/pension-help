# == Schema Information
# Schema version: 41
#
# Table name: locations
#
#  id                 :integer(11)   not null, primary key
#  agency_id          :integer(11)   
#  name               :string(255)   
#  name2              :string(255)   
#  is_hq              :boolean(1)    
#  is_provider        :boolean(1)    
#  tollfree           :string(20)    
#  tollfree_ext       :string(10)    
#  phone              :string(20)    
#  phone_ext          :string(10)    
#  tty                :string(20)    
#  tty_ext            :string(10)    
#  fax                :string(20)    
#  email              :string(255)   
#  hours_of_operation :string(255)   
#  logistics          :string(255)   
#  updated_at         :datetime      
#  legacy_code        :string(10)    
#  legacy_subcode     :string(10)    
#  fmp2_code          :string(10)    
#  updated_by         :string(255)   
#  url                :string(255)   
#  url_title          :string(255)   
#  url2               :string(255)   
#  url2_title         :string(255)   
#  position           :integer(11)   
#

class Location < ActiveRecord::Base  
  belongs_to :agency
  has_many :addresses, :dependent => :destroy
  has_one :restriction, :dependent => :destroy
  
  has_one :mailing_address, :class_name => 'Address', 
            :conditions => "address_type = 'mailing'"
  has_one :dropin_address, :class_name => 'Address', 
            :conditions => "address_type =  'dropin'"
  
  composed_of :pha_contact, :class_name => PhaContact,
    :mapping => [
      [:pha_contact_name, :name],
      [:pha_contact_title, :title],
      [:pha_contact_phone, :phone],
      [:pha_contact_email, :email],
    ]

  attr_accessor :visible_in_view 
  
  def age_restrictions?
    sql = <<-SQL
        select
          l.id
        from
          locations l join restrictions r on r.location_id = l.id
        where
          l.id = ?
          and r.minimum_age is not null
        SQL

    Location.find_by_sql([sql, id]).size > 0
  end
  
  def income_restrictions?
   sql = <<-SQL
    select
      l.id
    from
      locations l join restrictions r on r.location_id = l.id
    where
      l.id = ?
      and r.max_poverty is not null 
      SQL

    Location.find_by_sql([sql, id]).size > 0
  end
  
  def and_restrictions?
    restriction.age_and_income unless restriction.nil?
  end

  #returns "NSP","DSP", or ""
  def get_provider_type
    unless restriction.nil?
      (restriction.minimum_age.nil? && restriction.max_poverty.nil?) ? 'NSP' : 'DSP'
    else
      'NSP'
    end
  end
end
