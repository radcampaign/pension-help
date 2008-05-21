# == Schema Information
# Schema version: 41
#
# Table name: counties
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  fips_code    :string(255)   
#  state_abbrev :string(255)   
#

class County < ActiveRecord::Base
  belongs_to :state
  has_many :cities
  has_many :zips
  def County.find_by_state_abbrevs(abbrevs)
    result = Array.new
    args = Array.new
    cond = ''
    unless abbrevs.nil?
      abbrevs.each_with_index do |abbrev,index|
        if index == 0
          cond += ' state_abbrev = ?'
        else
          cond += ' OR state_abbrev = ?'
        end
        args << abbrev
      end
      result = County.find(:all, :conditions => [cond, args].flatten)
    end
    result
  end
end
