class CreateStates < ActiveRecord::Migration
  class State < ActiveRecord::Base
  end
  def self.up
    create_table(:states, :id => false) do |t|
      t.column "abbrev", :string, :limit => 2
      t.column "name", :string, :limit => 50
    end
    execute "alter table states add primary key pk_states(abbrev)"
  end

  def self.down
    drop_table :states
  end
end
