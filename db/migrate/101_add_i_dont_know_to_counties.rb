class AddIDontKnowToCounties < ActiveRecord::Migration
  def self.up
    State.find(:all).each do |state|
      County.create! :name => "I don't know", :fips_code => "0",
        :state_abbrev => state.abbrev
    end
  end

  def self.down
    # do nothing here
  end
end
