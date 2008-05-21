# == Schema Information
# Schema version: 41
#
# Table name: states
#
#  abbrev :string(2)     not null, primary key
#  name   :string(50)    
#

class State < ActiveRecord::Base
  self.primary_key = 'abbrev'
  has_many :counties, :foreign_key => 'state_abbrev'
  
  def State.find_by_state_abbrevs(abbrevs)
    result = Array.new
    args = Array.new
    cond = ''
    unless abbrevs.nil?
      abbrevs.each_with_index do |abbrev,index|
        if index == 0
          cond += ' abbrev = ?'
        else
          cond += ' OR abbrev = ?'
        end
        args << abbrev
      end
      result = State.find(:all, :conditions => [cond, args].flatten)
    end
    result
  end
end
