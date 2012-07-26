class AddIDontKnowToCities < ActiveRecord::Migration
  def self.up
    State.find(:all).each do |state|
      state.counties.each do |county|
        City.create! :name => "I don't know", :county_id => county.id,
          :state_abbrev => state.abbrev
      end
    end
  end

  def self.down
    # do nothing here
  end
end
