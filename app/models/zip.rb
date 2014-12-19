# == Schema Information
#
# Table name: zips
#
#  zipcode      :string(255)      default(""), not null, primary key
#  state_abbrev :string(255)
#  county_id    :integer
#

class Zip < ActiveRecord::Base
  self.primary_key = 'zipcode'

    # override find to restrict zip to first 5 digits
  def self.find(*args)
    args=args.first[0..4] if args.first.is_a?(String) && args.size == 1
    super(args)
  end

end
